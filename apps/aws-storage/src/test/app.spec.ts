import request from "supertest"
import app from "../app/app"

describe("test", () => {
    it("Video from s3 bucket (GET /api/video)", async () => {
        const res = await request(app).get("/video?path=SampleVideo_1280x720_1mb.mp4")
        expect(res.statusCode).toBe(200)
        expect(res.headers["content-type"]).toBe("video/mp4")
    })

})
