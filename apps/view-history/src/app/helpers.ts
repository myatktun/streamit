import amqp from "amqplib"
import { MongoClient, Document } from "mongodb"

if (!process.env.DBHOST) {
    throw new Error("Environment variable DBHOST not specified")
}

if (!process.env.DBNAME) {
    throw new Error("Environment variable DBNAME not specified")
}

const DBHOST = process.env.DBHOST
const DBNAME = process.env.DBNAME

const connectRabbit = async () => {
    try {
        console.log("Connecting to RabbitMQ server")
        const messageConnection = await amqp.connect("amqp://rabbitmq")
        console.log("Connected to RabbitMQ")
        return messageConnection
    } catch (error) {
        return new Error(<string>error)
    }
}

const consumeViewedMessage = async (
    videosCollection: Document,
    messageChannel: amqp.Channel
) => {
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
}

export const connectDB = async () => {
    try {
        const client = await MongoClient.connect(DBHOST)
        const db = client.db(DBNAME)
        return db.collection("videos")
    } catch (error) {
        return new Error(<string>error)
    }
}

export const startMessageQueue = async () => {
    const videosCollection = await connectDB()
    const messageConnection = await connectRabbit()

    if (messageConnection instanceof Error) {
        throw messageConnection
    }

    const messageChannel = await messageConnection.createChannel()
    await messageChannel.assertQueue("viewed", {})
    console.log("Asserted that the 'viewed' queue exists")

    await consumeViewedMessage(videosCollection, messageChannel)
}
