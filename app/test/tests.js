const expect  = require('chai').expect;
const request = require('request');
require('dotenv').config()
const port = process.env.PORT || 3000;
describe('Status and content', function() {
    describe ('Main page', function() {
        it('status', async function(){
            request(`http://localhost:${port}/`, function(error, response, body) {
                expect(response.statusCode).to.equal(200);
                
            });
        });

        it('content',  async function() {
            request(`http://localhost:${port}/` , function(error, response, body) {
                let time = parseInt(body)
                expect(new Date(time).getTime()).to.be.above(0);
              
            });
        });
    });
});