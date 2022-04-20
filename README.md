# RADServer Samples

I plan to add a number of RAD Server Examples here. 
Many of the previous RAD Server code snippets are linked to blogs on https://delphiaball.co.uk/tag/rad-server/

## TRESTRequestDataSetAdapter Example
The TRESTResponseDataSetAdapter can be used converts a JSON array response into a TDataSet.
The TRESTRequestDataSetAdapter works in the opposite direction, by coverting a TDataSet into a Post, Put, or Delete request to update the remote data. 
The TaskExample sample includes a RAD Server Package and a Client application (just setup the DB path in the package to run it). You can copy and drop the REST.DataUpdater unit into your own application. REST.DataUpdater extend the FireDAC framework to rapidly post updates back to the server. While its recommended to run each request as it comes in, it also allows changes to cache into memory to bulk update.

Discover the example on YouTube
https://youtu.be/7O1B9LsYUPE

## SenchaMail
The SenchaMail sample example uses the SENCHAMAILSERVER.IB database. (found in the data folder)
This is an InterBase database that stores emails, contacts, and labels that are applied to the email. 
To use the sample, either place the database at C:\data\SENCHAMAILSERVER.IB or update the connection path in the FDConnection1 components found in unitLabels and unitData.

The sample acts as a backend for persisting data from the JavaScript client sample created by Stuart98
https://github.com/Stuart98/ext-mail/

