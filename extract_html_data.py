from HTMLParser import HTMLParser
import sys

# create a subclass and override the handler methods
class MyHTMLParser(HTMLParser):
    strdata = []
    def handle_data(self, data):
        #Desconsidera os "data" que iniciam com o caracter espacco
        if data[0] != ' ':
            # Alguns campos "data" possuem a unidade de medida (ex: 10 dB). Como a unidade eh separada por espacco, o split separa a string e somente o valor e adicionado ao array strdata
            self.strdata.append(data.split(' ')[0])


# instantiate the parser and fed it some HTML
parser = MyHTMLParser()
parser.feed(sys.stdin.readlines()[0].strip('\n'))

#O html parser encontra duas strings (data), que sao armazenados em um array
# 0 - Uma string que descreve o significado do campo
# 1 - Uma string que contem o valor do campo
print sys.argv[1]+"="+parser.strdata[1]
