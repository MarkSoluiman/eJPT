
---

## Passive Crawling & Spidering with Burp Suite & OWASP ZAP

### Spidering

Spidering is the process of automatically discovering new resources (URLs) on a web application/site.

It typically begins with a list of target URLs called seeds, after which the Spider will visit the URLs and identified hyperlinks in the page and adds them to the list of of URLs to visit and repeats the process recursively.

Spidering can be quite loud and as a result, it is typically considered to be an active information gathering technique.

We can utilize OWASP ZAP's Spider to automate the process of spidering a web application to map out the web application and learn more about how the site is laid out and how it works.

To use passive crawling in BurpSuite, we need to  turn on the foxy proxy plugin in our web browser. However, proxy should be turned off in BurpSuite. Upon visiting the target website and clicking on links and visiting pages, BurpSuite will start to map the website and we can find the results under "Target" -> "Site map" in BurpSuite.




 