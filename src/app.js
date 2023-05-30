const exp = require('./server');
const utils = require('./utils');

const server = exp.listen(utils.port, () => {
    console.log(`listening with message "${utils.content}"`);
});

// Shut down after 60 sec
setTimeout(() => {
    console.log('closing');
    server.close();
}, 60000);