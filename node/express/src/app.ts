import express from "express"

const app = express()

app.get("/", (_, res) => { res.status(200).json("Hello world") })

app.listen(3000, () => {
  console.log("Server opened at http://localhost:3000")
})
