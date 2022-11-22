import { MongoClient } from "mongodb"
import amqp from "amqplib"

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

export const createMessageChannel = async () => {
    try {
        console.log("Connecting to RabbitMQ")
        const messageConnection = await amqp.connect(RABBITMQ)
        console.log("Connected to RabbitMQ")
        if (messageConnection instanceof Error) {
            throw messageConnection
        }
        const messageChannel = await messageConnection.createChannel()
        return messageChannel
    } catch (error) {
        return new Error(<string>error)
    }
}

export const connectDB = async () => {
    console.log("Connecting to Database")
    const client = await MongoClient.connect(DBHOST)
    const db = client.db(DBNAME)
    console.log("Connected to Database")
    return db
}

export const sendViewMessage = async (
    messageChannel: amqp.Channel,
    videoPath: string
) => {
    console.log("Publishing message on 'viewed' queue")
    const msg = { videoPath: videoPath }
    const jsonMsg = JSON.stringify(msg)
    messageChannel.publish("", "viewed", Buffer.from(jsonMsg))
}
