///////////////////////////////////////////////////////////////////////////////////////////////
//  Dependencies library axios                                                               //
//  1. run npm install -g axios                                                              //
//  2. export path before call these script to make node in path                             //
//  E.g. :export PATH=/home/ubuntu/.nvm/versions/node/v8.5.0/bin:$PATH                       //
//  3. export NODE_PATH to global node_modules to make this script can require that library  //
//  E.g. : export NODE_PATH=/home/ubuntu/.nvm/versions/node/v8.5.0/lib/node_modules          //
///////////////////////////////////////////////////////////////////////////////////////////////
const axios = require('axios')
let functionName = process.argv[2]
let domainContext = process.argv[3] || ""
let host= process.argv[4] || "http://smith.tnis.com"

const sleeptime = 2000
const maxWaitTime = 600000 // ten minute
const maxErrorTime = 60000 // one minute

var instance = axios.create({
    baseURL: host
})

functionName=functionName.split(`"`).join(``)
domainContext=domainContext.split(`"`).join(``)
console.log(`waiting for job ${functionName} to complete in domain ${domainContext}`)
//2006-01-02
let date = formatdate(new Date());
let url = `/${domainContext}/v1/jobinfo?name=${functionName}&date=${date}`
console.log("url : " + url)
console.log("start : ", Date.now())

handleWaitJob(0,0)

function getJobInfo() {
    return instance.get(url)
        .then(response => {
            if (response.data.rsBody.jobInfo_list[0].is_ignored) {
                // if latest job_info is_ignore true, it means that current job is not start yet (pod is creating)
                return "error"
            }
            console.log(response.data.rsBody)
            return response.data.rsBody.jobInfo_list[0].status
        })
        .catch(function (error) {
            return "error"
        });
}
async function handleWaitJob(count,errorCount) {
    var result = await getJobInfo()
    switch (result){    
        case "In Progress":
            console.log(`In Progress for ${count*sleeptime/1000} seconds (Max=${maxWaitTime/1000})`)
            if(count*sleeptime < maxWaitTime) {
                await sleep(sleeptime)
                handleWaitJob(++count,0) 
            }else{
                console.log(`Max Wait Time Exceed(${maxErrorTime}) : Job is in progress for too long`)
                process.exit(1)
            }
            break
        case "error":
            console.log(`Job not found or Something went wrong for ${(errorCount*sleeptime)/1000} seconds (Max=${maxErrorTime/1000})`)
            if(errorCount*sleeptime < maxErrorTime && count*sleeptime < maxWaitTime){
                await sleep(sleeptime)
                handleWaitJob(++count,++errorCount)
            }else{
                console.log(errorCount*sleeptime >= maxErrorTime ? "Max Error Time Exceed : Cannot call Api JobInfo":"Max Wait Time Exceed : Job is in progress for too long")
                process.exit(1)
            }
            break
        case "Job Fail":
            console.log(`Time ${count*sleeptime/1000} sec, Result :`,result)
            process.exit(1)
        default:
            console.log()
            console.log(`Time ${count*sleeptime/1000} sec, Result :`,result)
    }
}
function sleep(ms) {
    return new Promise((resolve, reject) => {
        setTimeout(() => resolve("OK"), ms)
    })
}

function formatdate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;
    return [year, month, day].join('-');
}
