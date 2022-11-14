import express from "express"
import { request } from 'http'
import { MongoClient, ObjectId } from 'mongodb'

const app = express()

if (!process.env.VIDEO_STORAGE_HOST) {
    throw new Error("Environment variable VIDEO_STORAGE_HOST not specified")
}

if (!process.env.VIDEO_STORAGE_PORT) {
    throw new Error("Environment variable VIDEO_STORAGE_PORT not specified")
}

if (!process.env.DBHOST) {
    throw new Error("Environment variable DBHOST not specified")
}

if (!process.env.DBNAME) {
    throw new Error("Environment variable DBNAME not specified")
}

const VIDEO_STORAGE_HOST = process.env.VIDEO_STORAGE_HOST
const VIDEO_STORAGE_PORT = process.env.VIDEO_STORAGE_PORT
const DBHOST = process.env.DBHOST
const DBNAME = process.env.DBNAME

console.log(`Forwarding requests to ${VIDEO_STORAGE_HOST}:${VIDEO_STORAGE_PORT}`)

app.use(express.json())

const connectDB = async () => {
    const client = await MongoClient.connect(DBHOST)
    const db = client.db(DBNAME)
    return db.collection("videos")
}

app.get('/video', async (req, res) => {

    if (typeof req.query.id !== 'string') {
        res.status(404).send("Error, wrong id")
        return
    }

    const videoCollection = await connectDB()
    const videoId = new ObjectId(req.query.id)
    const videoRecord = await videoCollection.findOne({ _id: videoId })
    if (!videoRecord) {
        res.status(404).send("Video not found")
        return
    }

    console.log(`Translated id ${videoId} to path ${videoRecord.videoPath}`)

    const forwardRequest = request(
        {
            host: VIDEO_STORAGE_HOST,
            port: VIDEO_STORAGE_PORT,
            path: `/video?path=${videoRecord.videoPath}`,
            method: 'GET',
            headers: req.headers
        },
        forwardResponse => {
            res.writeHead(<number>forwardResponse.statusCode, forwardResponse.headers)
            forwardResponse.pipe(res)
        }
    )
    req.pipe(forwardRequest)
})

export default app
