const expect  = require('chai').expect;
const request = require('request');
describe('Status and content', function() {
    describe ('Main page', function() {
        it('status', async function(){
            request('http://localhost:8000/', function(error, response, body) {
                expect(response.statusCode).to.equal(200);
                
            });
        });

        it('content',  async function() {
            request('http://localhost:8000/' , function(error, response, body) {
                let time = parseInt(body)
                expect(new Date(time).getTime()).to.be.above(0);
              
            });
        });
    });
});