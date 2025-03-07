import { check, sleep } from 'k6';
import http from 'k6/http';
import { Counter, Rate } from 'k6/metrics';

export let options = {
  vus: 20, // 20 virtual users
  duration: '1m', // Test duration
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests should be below 500ms
  },
};

const successRate = new Rate('successful_requests');
const totalRequests = new Counter('total_requests');
const failedRequests = new Counter('failed_requests');

export default function () {
  const params = {
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + __ENV.ACCESS_TOKEN,
    },
  }
  const res = http.get('http://localhost:3000/attendances', params);
  totalRequests.add(1);

  const success = check(res, {
    'is status 200': (r) => r.status === 200,
  });

  successRate.add(success);
  if (!success) {
    failedRequests.add(1);
  }

  sleep(1); // Simulate user wait time
}
