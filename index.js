const express = require("express")

const app = express()

app.get("/", async(req,res)=>{
    return res.json({
        status:201,
        body:'Get Message'
    })
})

app.listen(8000,()=>{
    console.log(`Server running on PORT = 8000. `)
})
