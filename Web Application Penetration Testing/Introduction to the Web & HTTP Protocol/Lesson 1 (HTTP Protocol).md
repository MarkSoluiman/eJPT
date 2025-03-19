
---

## Introduction to HTTP

HTTP has 2 versions: HTTP 1.0 & HTTP 1.1.

HTTP 1.1 is the most widely used version and has several advantages  over HTTP 1.0 such as the ability to re-use the same connection and can request multiple URI's/Resources.


---

## HTTP Requests 

### Request Line
The request line is the first line of an HTTP request and contains the following three components:
- **HTTP method (e.g GET, POST, DELETE,etc):** Includes the type of request being made.
- **URL (Uniform Resource Locator):** The address of the resource the client wants to access.
- **HTTP version:** The version of the HTTP protocol being used.
### Request Headers

Headers provide additional information about the request. Common headers include:
- **User-Agent**: information about the client making the request (e.g browser type).
- **Host**: The hostname of the server.
- **Accept:** The media types the client can handle in the response (e.g HTML, JSON).
- **Authorization:** Credentials for authentication, if required.
- **Cookie:** Information stored on the client-side and sent back to the server with each request.

### Request Body (Optional)

Some HTTP methods (e.g POST or PUT) include a request body where data is sent to the server, typically in JSON or form data format.

### HTTP Request Example
![[Pasted image 20250316231931.png]]


### HTTP Request Methods Explained

| Method   | Function |
|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **GET**  | The GET method is used to retrieve data from the server. It requests the resource specified in the URL and does not modify the server's state. It is a safe and idempotent method, meaning that making the same GET request multiple times should not have any side effects. |
| **POST** | The POST method is used to submit data to be processed by the server. It typically includes data in the request body, and the server may perform actions based on that data. POST requests can cause changes to the server's state, and they are not idempotent. |
| **PUT**  | The PUT method is used to update or create a resource on the server at the specified URL. It replaces the entire resource with the new representation provided in the request body. If the resource does not exist, PUT can create it. |
| **DELETE** | The DELETE method is used to remove the resource specified by the URL from the server. After a successful DELETE request, the resource will no longer be available at that URL. |
| **PATCH** | The PATCH method is used to apply partial modifications to a resource. It is similar to the PUT method but only updates specific parts of the resource rather than replacing the entire resource. |
| **HEAD**  | The HEAD method is similar to the GET method but only retrieves the response headers and not the response body. It is often used to check the headers for things like resource existence or modification dates. |
| **OPTIONS** | The OPTIONS method is used to retrieve information about the communication options available for the target resource. It allows clients to determine the supported methods and headers for a particular resource. |



### HTTP Request Host Header

This is the beginning of HTTP Request Headers. HTTP Headers have the following structure: Header-name: Header-value.

The Host header allows a web server to host multiple websites at a single IP address. Our browser is specifying in the Host header which website we are interested in. 

Note, Host value + Path combine to create the full URL we are requesting. For example, the home page of facebook: "www.facebook.com/"

### HTTP Request User-Agent Header

The User-Agent is used to specify and send our browser, browser version, operating system and language to the remote web server.

All web browsers have their own User-Agent identification string. This is how most websites recognize the type of browser in use.

### HTTP Request Accept Header

The Accept header is used by our browser to specify which document/file types are expected to be returned from the web server as a result of this request.

### HTTP Request Accept-Encoding Header

The Accept-Encoding header is similar to Accept, and is used too restrict the content encoding that is acceptable in the response.

Content encoding is primarily used to allow a document to be compressed or transformed without  losing the original format and without the loss of information.

### HTTP Request Connection Header

When using HTTP 1.1, we can maintain/re-use the connection to the remote web server for an unspecified amount of time using the value "keep-alive". 

This indicates that all requests to the web server will continue to be sent through this connection without initiating a new connection every time (as in HTTP 1.0).

---

## HTTP Responses 

### Response Headers

Similar to request headers, response headers provide additional information about the response. Common headers include:
- **Content-Type**: The media type of the response content (e.g text/html, application/JSON).
- **Content-Length:** The size of the response body in bytes.
- **Set-Cookie:** Used to set cookies on the client-side for subsequent requests.
- **Cache-Control:** Directives for caching behavior.


### Response Body (Optional)

The response body contains the actual content of the response. For example, in the case of an HTML page, the response body will contain the HTML markup. 

### HTTP Request Response Example

In response to the HTTP Request, the web server will respond with the requested resource, preceded by a bunch of new HTTP response headers.

These new response headers from the web server will be used by our web browser to interpret the content contained in the Response content/body of the response.

![[Pasted image 20250317001846.png]]

### HTTP Status-Line

The first line of an HTTP Response is the Status-Line, consisting of the protocol version (HTTP 1.1) followed by the HTTP status code (200) and its relative textual meaning (OK).

### Common HTTP Status Codes

| Status Code                   | Meaning                                                                                                                                                                   |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **200 OK**                    | The request was successful, and the server has returned the requested data.                                                                                               |
| **301 Moved Permanently**     | The requested resource has been permanently moved to a new URL, and the client should use the new URL for all future requests.                                            |
| **302 Found**                 | The requested resource is temporarily located at a different URL. This code is commonly used for temporary redirections, but it's often better to use 303 or 307 instead. |
| **400 Bad Request**           | The server cannot process the request due to a client error (e.g., malformed request syntax).                                                                             |
| **401 Unauthorized**          | Authentication is required, and the client must provide valid credentials to access the requested resource.                                                               |
| **403 Forbidden**             | The server understood the request, but the client does not have permission to access the requested resource.                                                              |
| **404 Not Found**             | The requested resource could not be found on the server.                                                                                                                  |
| **500 Internal Server Error** | The server encountered an error while processing the request, and the specific cause is not provided.                                                                     |

### HTTP Response Date Header

The Date header in an HTTP response is used to indicate the date and time when the response was generated by the server.

It helps clients and intermediaries to understand the freshness of the response and to synchronize the time between the server and the client.

### HTTP Response Cache-Control Header

The Cache headers allow the Browser and the Server to agree about caching rules. It allows web servers to instruct clients on how long they can cache the response and under what conditions they should re-validate it with the server.

This helps in optimizing the performance and efficiency of web applications by reducing unnecessary network requests.

### Cache-Control Directives

| Directive | Meaning |
|-----------|----------------------------------------------------------------------------------------------------------------------------------|
| **Public** | Indicates that the response can be cached by any intermediary caches (such as proxy servers) and shared across different users. |
| **Private** | Specifies that the response is intended for a specific user and should not be cached by intermediate caches. |
| **no-cache** | Instructs the client to revalidate the response with the server before using the cached version. It does not prevent caching but requires revalidation. |
| **no-store** | Directs the client and intermediate caches not to store any version of the response. It ensures that the response is not cached in any form. |
| **max-age=&lt;SECONDS&gt;** | Specifies the maximum amount of time in seconds that the response can be cached by the client. After this period, the client should revalidate with the server. |

### HTTP Response Content-Type Header

The Content-Type header in an HTTP Response is used to indicate the media type of the response content.

It tells the client what type of data the server is sending so that the client can handle it appropriately.

### HTTP Response Content-Encoding Header

The Content-Encoding header in an HTTP response is used to specify the compression encoding applied to the response content.

It tells the client how the server has encoded the response data, allowing the client to decode and decompress the data correctly.

### HTTP Response Server Header

The Server header displays the Web Server banner, for example, Apache, Nginx, IIS ,etc.

Google uses a custom web server banner: gws (Google Web Server).

---

## HTTP Basics Lab

To show a page from a website using curl: `curl -v (website)`

To only get a Head Response: `curl -v -I (website page)`

To see the allowed HTTP Methods: `curl -v -X OPTIONS (website page)`. Note, OPTION has to be allowed to get an 200 OK response.

If we found a page that we can upload files to, we can upload files by: `curl (path to website page) --upload-file (path to file)`


