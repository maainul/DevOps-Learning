const app = require("./index");
const client = require("prom-client")
const responseTime = require("response-time")

const { createLogger, transports } = require("winston");
const LokiTransport = require("winston-loki");
const options = {
  transports: [
    new LokiTransport({
        labels:{
            appName:"express"
        },
       host: "http://34.224.64.171:3100"
    })
  ]
};
const logger = createLogger(options);



// Default Metrics Collection
client.collectDefaultMetrics({ register: client.register });

// Custom Metrics
const reqResTime = new client.Histogram({
    name:'http_express_req_res_time',
    help:'This tells how much time is taken by req and res',
    labelNames:["method","route","status_code"],
    buckets:[1,50,100,200,400,500,800,1000,2000]
})
// total request to the server
const totalReqCounter = new client.Counter({
    name:'total_request_counter',
    help:'Tells total Request'
})

// Respose time for a route
app.use(responseTime((req,res,time)=>{
    totalReqCounter.inc();
    reqResTime.labels({
        method:req.method,
        route:req.url,
        status_code:res.statusCode
    }).observe(time)
}))





// Metrics Endpoint for Prometheus
app.get("/metrics", async (req, res) => {
    res.setHeader("Content-Type", client.register.contentType);
    const metrics = await client.register.metrics();
    res.send(metrics);
  })

const PORT = 8000;

app.listen(PORT, () => {
    console.log(`Server running on PORT = ${PORT}.`);
});
