const request = require('supertest');
const server = require('../src/server');

describe('GET', () => {

    it('server is running', async () => {
        const resp = await request(server).get('/')
        expect(resp.status).toBe(200);
    });

});

