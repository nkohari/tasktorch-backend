require('coffee-script/register');

var ApiApplication = require('./src/ApiApplication');
app = new ApiApplication();
app.start();
