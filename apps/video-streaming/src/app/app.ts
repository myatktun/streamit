import express from "express"
import { request } from "http"
import { ObjectId } from "mongodb"
import { connectDB, createMessageChannel, sendViewMessage } from "./helpers"

const app = express()

app.use(express.json())

if (!process.env.VIDEO_STORAGE_HOST) {
    throw new Error("Environment variable VIDEO_STORAGE_HOST not specified")
}

if (!process.env.VIDEO_STORAGE_PORT) {
    throw new Error("Environment variable VIDEO_STORAGE_PORT not specified")
}

const VIDEO_STORAGE_HOST = process.env.VIDEO_STORAGE_HOST
const VIDEO_STORAGE_PORT = process.env.VIDEO_STORAGE_PORT

console.log(
    `Forwarding requests to ${VIDEO_STORAGE_HOST}:${VIDEO_STORAGE_PORT}`
)

const messageChannel = createMessageChannel()
const dbCon = connectDB()

app.get("/video", async (req, res) => {
    if (typeof req.query.id !== "string") {
        res.status(404).send("Error, wrong id")
        return
    }

    const videoCollection = (await dbCon).collection("videos")
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
            method: "GET",
            headers: req.headers,
        },
        (forwardResponse) => {
            res.writeHead(
                <number>forwardResponse.statusCode,
                forwardResponse.headers
            )
            forwardResponse.pipe(res)
        }
    )
    req.pipe(forwardRequest)

    const channel = await messageChannel
    if (channel instanceof Error) {
        throw channel
    }
    await sendViewMessage(channel, videoRecord.videoPath)
})

export default app
