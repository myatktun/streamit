// import app from "./app/app"
import { MongoClient } from "mongodb"
import amqp from "amqplib"
import express from "express"
import bodyParser from "body-parser"

if (!process.env.PORT) {
    throw new Error("Environment variable PORT not specified")
}

if (!process.env.DBHOST) {
    throw new Error("Environment variable DBHOST not specified")
}

if (!process.env.DBNAME) {
    throw new Error("Environment variable DBNAME not specified")
}

const PORT = process.env.PORT
const DBHOST = process.env.DBHOST
const DBNAME = process.env.DBNAME

// const connectDB = async () => {
//     const client = await MongoClient.connect(DBHOST)
//     const db = client.db(DBNAME)
//     return db.collection("videos")
// }

// async function consumeViewedMessage(msg) {
//     console.log("Received a 'viewed' message")

//     const parsedMsg = JSON.parse(msg.content.toString)
//     await videosCollection.insertOne({videoPath: parsedMsg.videoPath})
//     console.log("Acknowledging message was handled")
//     messageChannel.ack(msg)
// }

const main = async () => {
    try {
        const app = express()
        app.use(bodyParser.json())
        const client = await MongoClient.connect(DBHOST)
        const db = client.db(DBNAME)
        const videosCollection = db.collection("videos")

        console.log("Connecting to RabbitMQ server")

        const messageConnection = await amqp.connect("amqp://rabbitmq")

        console.log("Connected to RabbitMQ")

        const messageChannel = await messageConnection.createChannel()
        await messageChannel.assertQueue("viewed", {})
        console.log("Asserted that the 'viewed' queue exists")

        await messageChannel.consume("viewed", async (msg) => {
            console.log("Received a 'viewed' message")
            if (msg == null) {
                throw new Error("msg is null")
            }
            const parsedMsg = JSON.parse(msg.content.toString())
            await videosCollection.insertOne({ videoPath: parsedMsg.videoPath })
            console.log("Acknowledging message was handled")
            messageChannel.ack(<amqp.ConsumeMessage>msg)
        })

        app.get("/history", async (req, res) => {
            if (
                typeof req.query.skip !== "string" ||
                typeof req.query.limit !== "string"
            ) {
                return
            }
            const skip = parseInt(req.query.skip)
            const limit = parseInt(req.query.limit)
            const document = await videosCollection
                .find()
                .skip(skip)
                .limit(limit)
                .toArray()
            res.json({ history: document })
        })

        app.listen(PORT, () => {
            console.log(`View History service on port ${PORT}`)
        })
    } catch (error) {
        console.error(error)
    }
}

main()
