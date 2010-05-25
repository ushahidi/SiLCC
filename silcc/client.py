"""Python Bindings for SiLCC tagging API"""
import urllib2
import urllib

import simplejson

def tag(text, key=None, urlbase='http://opensilcc.com/api/tag'):
    """Calls the SilCC web service API"""
    if type(text) == unicode:
        text = text.encode('utf-8')
    values = dict(text=text)
    if key:
        values['key'] = key
    data = urllib.urlencode(values)
    request = urllib2.Request(urlbase, data)
    json_response = urllib2.urlopen(request)
    json_data = json_response.read()
    json_response.close()
    retval = simplejson.loads(json_data)
    return retval

if __name__ == '__main__':
    tags = tag("Ushahidi is a platform for tracking crisis data")
    print tags

