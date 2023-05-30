const utils = require('../src/utils');

describe('Utils', () => {

    test('adds 1 + 2 to equal 3', () => {
        expect(utils.sum(1, 2)).toBe(3);
    })
    test('port is 60111', () => {
        expect(utils.port).toBe(60111);
    })
    test('content to be "content"', () => {
        expect(utils.content).toBe('content');
    })

});