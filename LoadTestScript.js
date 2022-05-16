import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
    stages: [
        { duration: '10s', target: 10 },
        { duration: '10s', target: 20 },
        { duration: '10s', target: 30 },
        { duration: '20s', target: 30 },
        { duration: '10s', target: 0 },
    ],
    thresholds: { 
        http_req_failed: ['rate<0.01'], // http errors should be less than 1%
        http_req_duration: ['p(99)<400'], // 99% of requests should be below 500ms
        http_req_duration: ['p(95)<350'], // 95% of requests should be below 350ms
    },
  };
  
export default function () {
    http.get("http://weatherforecast.eastus.azurecontainer.io/weatherforecast");
    sleep(0.1);
}