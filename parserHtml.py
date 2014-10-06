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
        opts, argrs = getopt.getopt(argv, 'hu:k:', '[help, url, key]')
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
    regexp = buildRegex(key)
    links = regexp.finditer(html)
    #costruiamo la lista giusta senza doppioni
    linkWithoutDuplicates = buildLinkList(links)
    doHostCommand(linkWithoutDuplicates)


#Funzione che restitutisce la regexp corretta ricavandola dalla key immessa
def buildRegex(key):
    #inizimo dalla regex di base
    regex = "http://[^\"]*.*"
    #splittiamo sul punto cosi da poter fare l escape con il \ (nelle regex il . equivale al match di qualsiasi carattere se non ha lescape)
    parts = key.split(".")
    #per ogni segmento
    for index, value in enumerate(parts):
        #se e l ultimo non mettto il punto con escape
        if index == (len(parts) - 1):
            regex = regex + value
        #a tutti gli altri segmenti ncodo il punto con escape
        else:
            regex = regex + value + "\."
    #aggiungiamo la parte finale
    regex = regex + ".*"
    return re.compile(r'' + regex)

def buildLinkList(links):
    #iniziamo a costruire la lista
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
    return linkWithoutDuplicates

def doHostCommand(linkList):
    for link in linkList:
        command = 'host ' + link
        a = call(command, shell=True)


if __name__ == "__main__":
   main(sys.argv[1:])
