import urllib2, sys, getopt, re
from subprocess import call

def main(argv):
    #variabili per tenere traccia delle opzioni inserite
    #dominio su cui effettuare la ricerca
    url = ''
    #parolachiave su cui cosruire la regex
    key = ''
    #ricaviamo le opzioni inserite
    try:
        opts, argrs = getopt.getopt(argv, 'hu:k', '[help, url, key]')
    #se non  metto tutte le opzioni visualizza l'helper(non funzionante)
    except getopt.GetoptError:
        print 'usage : parserHtml.py -u <url> -k <key>'
        sys.exit(2)
    for opt, arg in opts:
        if opt in ('-h', '--help'):
             print 'usage :  parserHtml.py -u <url> -k <key>'
             sys.exit()
        elif opt in ('-u', '--url'):
            url = arg
        elif opt in ('-k', '--key'):
            key = arg
    #scarichiamo la pagina da analizzare
    response = urllib2.urlopen('http://' + url)
    html = response.read()
    #ricaviamo i link all interno della pagina
    regexp = re.compile(r'http://[^"]*.*cisco\.com.*')
    links = regexp.finditer(html)
    #iniziamo a costruire la nostra lista di link
    linkList = []
    #ricaviamo la parte di link interessante depurando lla stringa da parti non volute
    for link in links:
       linkPart = link.group().split("/")
       #ci interessano solo i sottodomini in questo caso
       linkCorrect = linkPart[2]
       linkList.append(linkCorrect)
    #togliamo i doppioni dalla lista
    linkWithoutDuplicates = set(linkList)
    #stampiamo la lista definitiva
    for link in linkWithoutDuplicates:
        print link



if __name__ == "__main__":
   main(sys.argv[1:])
