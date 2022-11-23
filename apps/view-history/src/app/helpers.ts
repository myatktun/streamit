import amqp from "amqplib"
import { MongoClient, Document, Db } from "mongodb"

if (!process.env.DBHOST) {
    throw new Error("Environment variable DBHOST not specified")
}

if (!process.env.DBNAME) {
    throw new Error("Environment variable DBNAME not specified")
}

if (!process.env.RABBITMQ) {
    throw new Error("Environment variable RABBITMQ not specified")
}

const DBHOST = process.env.DBHOST
const DBNAME = process.env.DBNAME
const RABBITMQ = process.env.RABBITMQ

const connectRabbit = async () => {
    try {
        console.log("Connecting to RabbitMQ")
        const messageConnection = await amqp.connect(RABBITMQ)
        console.log("Connected to RabbitMQ")
        return messageConnection
    } catch (error) {
        return new Error(<string>error)
    }
}

const consumeViewedMessage = async (
    queue: string,
    videosCollection: Document,
    messageChannel: amqp.Channel
) => {
    await messageChannel.consume(queue, async (msg) => {
        console.log("Received a 'viewed' message")
        if (msg == null) {
            throw new Error("msg is null")
        }
        const parsedMsg = JSON.parse(msg.content.toString())
        await videosCollection.insertOne({ videoPath: parsedMsg.videoPath })
        console.log("Acknowledging message was handled")
        messageChannel.ack(msg)
    })
}

export const connectDB = async () => {
    console.log("Connecting to Database")
    const client = await MongoClient.connect(DBHOST)
    const db = client.db(DBNAME)
    console.log("Connected to Database")
    return db
}

export const startMessageQueue = async (dbCon: Promise<Db>) => {
    const videosCollection = (await dbCon).collection("videos")
    const messageConnection = await connectRabbit()

    if (messageConnection instanceof Error) {
        throw messageConnection
    }

    const messageChannel = await messageConnection.createChannel()
    await messageChannel.assertExchange("viewed", "fanout")
    // "exclusive: true" will make queue auto deallocate when services disconnect
    const { queue } = await messageChannel.assertQueue("", { exclusive: true })
    console.log(`Created queue ${queue}, binding it to "viewed" exchange`)

    await messageChannel.bindQueue(queue, "viewed", "")

    await consumeViewedMessage(queue, videosCollection, messageChannel)
}
