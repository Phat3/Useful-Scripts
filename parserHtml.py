import urllib2, sys, getopt, re
from subprocess import call

def main(argv):
    url = ''
    key = ''
    try:
        opts, argrs = getopt.getopt(argv, 'hu:k', '[help, url, key]')
    except getopt.GetoptError:
        print 'parserHtml.py -u <url> -k <key>'
        sys.exit(2)
    for opt, arg in opts:
        if opt in ('-h', '--help'):
             print 'parserHtml.py -u <url> -k <key>'
             sys.exit()
        elif opt in ('-u', '--url'):
            url = arg
        elif opt in ('-k', '--key'):
            key = arg
    response = urllib2.urlopen('http://' + url)
    html = response.read()
    regexp = re.compile(r'http://[^"]*.*cisco\.com.*')
    links = regexp.finditer(html)
    linkList = []
    for link in links:
       linkPart = link.group().split("/")
       linkCorrect = linkPart[2]
       linkList.append(linkCorrect)
    linkWithoutDuplicates = set(linkList)
    for link in linkWithoutDuplicates:
        print link



if __name__ == "__main__":
   main(sys.argv[1:])
