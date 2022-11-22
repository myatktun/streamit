import express from "express"
import bodyParser from "body-parser"
import { connectDB, startMessageQueue } from "./helpers"

const app = express()

app.use(bodyParser.json())

startMessageQueue()

app.get("/history", async (req, res) => {
    if (
        typeof req.query.skip !== "string" ||
        typeof req.query.limit !== "string"
    ) {
        return
    }
    const skip = parseInt(req.query.skip)
    const limit = parseInt(req.query.limit)
    const videosCollection = await connectDB()
    if (videosCollection instanceof Error) {
        console.log(videosCollection)
        res.status(400)
        return
    }
    const document = await videosCollection
        .find()
        .skip(skip)
        .limit(limit)
        .toArray()
    res.json({ history: document })
})

export default app
