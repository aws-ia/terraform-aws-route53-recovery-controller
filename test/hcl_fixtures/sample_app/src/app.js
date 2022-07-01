/**
 * Copyright 2010-2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * This file is licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License. A copy of
 * the License is located at
 *
 * http://aws.amazon.com/apache2.0/
 *
 * This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
*/
var AWS = require('aws-sdk');
var express = require('express');
var bodyParser = require('body-parser');
const path = require('path');

AWS.config.region = process.env.REGION
console.log("Starting up...");
console.log("AWS Region [" + process.env.REGION + "]");
    
var ddbTable =  "nodejs-tutorial";

var ddb = new AWS.DynamoDB();
var app = express();

app.set('view engine', 'ejs');
app.set('views', __dirname + '/views');
app.use(bodyParser.urlencoded({extended:false}));
app.use('/static', express.static(path.join(__dirname, 'static')));

/*
Main page
*/
app.get('/', function(req, res) {
    res.render('index', {
        gt_region: AWS.config.region,
        static_path: 'static',
        theme: process.env.THEME || 'flatly',
        flask_debug: process.env.FLASK_DEBUG || 'false'
    });
});

/*
 SignUp logic
*/
app.post('/signup', function(req, res) {
    console.log("Accessing /SignUp endpoint");

    var item = {
        'email': {'S': req.body.email},
        'name': {'S': req.body.name},
        'preview': {'S': req.body.previewAccess},
        'theme': {'S': req.body.theme}
    };

    ddb.putItem({
        'TableName': ddbTable,
        'Item': item,
        'Expected': { email: { Exists: false } }        
    }, function(err, data) {
        if (err) {
            var returnStatus = 500;

            if (err.code === 'ConditionalCheckFailedException') {
                returnStatus = 409;
            }

            res.status(returnStatus).end();
            console.log('DDB Error: ' + err);
        } else {
            res.status(201).end();
        }
        
    });
});

var port = process.env.PORT || 3000;

var server = app.listen(port, function () {
    console.log('Server running at http://127.0.0.1:' + port + '/');
});