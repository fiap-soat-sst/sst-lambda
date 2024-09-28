import { handler } from './app.mjs';

const event = {
    headers: {
        //'x-user-cpf': '123.456.789-01',
        //'x-user-name': 'Marcelo Ribeiro',
        'x-api-key': '36a695dd-aec2-4544-8297-f1eff1bd4958'
    },
    methodArn: 'arn:aws:execute-api:region:account-id:api-id/stage/METHOD/resource-path'
};

handler(event).then(response => {
    console.log('Response:', JSON.stringify(response, null, 2));
}).catch(error => {
    console.error('Error:', error);
});