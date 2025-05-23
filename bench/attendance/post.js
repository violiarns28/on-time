import { check, sleep } from 'k6';
import http from 'k6/http';
import { Counter, Rate } from 'k6/metrics';

export let options = {
    vus: 20,
    duration: '10m',
};

const successRate = new Rate('successful_requests');
const totalRequests = new Counter('total_requests');
const failedRequests = new Counter('failed_requests');

export default function () {
    const randomType = Math.random() > 0.5 ? 'CLOCK_IN' : 'CLOCK_OUT';

    const payload = {
        type: randomType,
    }

    const res = http.post(`https://attendance-api.zenta.dev/attendances/simulate`, payload);

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
