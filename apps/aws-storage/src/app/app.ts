import express from 'express'
import { S3Client, GetObjectCommand, GetObjectCommandInput } from '@aws-sdk/client-s3'
import { Readable } from 'stream'

if (!process.env.S3_REGION) {
    throw new Error("Environment variable S3_REGION not set")
}

if (!process.env.S3_BUCKET) {
    throw new Error("Environment variable S3_BUCKET not set")
}

const app = express()

const S3_REGION = process.env.S3_REGION
const S3_BUCKET = process.env.S3_BUCKET

const s3Client = new S3Client({ region: S3_REGION })

const getObject = async (params: GetObjectCommandInput) => {
    try {
        const command = new GetObjectCommand(params)
        const object = await s3Client.send(command)
        return object
    } catch (error) {
        console.log("Error", error)
        return new Error(<string>error)
    }
}

app.get("/video", async (req, res) => {
    if (typeof req.query.path !== 'string') {
        res.status(404).send("Error")
        return
    }

    const videoPath = req.query.path
    console.log(`Streaming video from path ${videoPath}, requested by ${req.headers.host}`)

    const params: GetObjectCommandInput = {
        Bucket: S3_BUCKET,
        Key: videoPath
    }

    const object = await getObject(params)

    if (object instanceof Error) {
        res.status(404).send("Error")
        return
    }

    res.writeHead(200, {
        "Content-Length": object.ContentLength,
        "Content-Type": object.ContentType,
    })

    if (object.Body instanceof Readable) {
        object.Body.pipe(res)
    }
})

export default app
