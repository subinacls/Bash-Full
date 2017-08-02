#!/usr/bin/python
import pdb, optparse, sys
def airDumpOpen(file):
        """
        Takes one argument (the input file) and opens it for reading, Returns a list full of data
        """
        openedFile = open(file, "r")
        data = openedFile.readlines()
        cleanedData = []
        for line in data:
                cleanedData.append(line.rstrip())
        openedFile.close()
        return cleanedData

def airDumpParse(cleanedDump):
        """
        Function takes parsed dump file list and does some more cleaning, Returns a list of 2 dictionaries (Clients and APs)
        """
        try: #some very basic error handeling to make sure they are loading up the correct file
                try:
                        apStart = cleanedDump.index('BSSID, First time seen, Last time seen, Channel, Speed, Privacy, Power, # beacons, # data, LAN IP, ESSID')
                except Exception:
                        apStart = cleanedDump.index('BSSID, First time seen, Last time seen, channel, Speed, Privacy, Cipher, Authentication, Power, # beacons, # IV, LAN IP, ID-length, ESSID, Key')
                del cleanedDump[apStart] #remove the first line of text with the headings
                try:
                        stationStart = cleanedDump.index('Station MAC, First time seen, Last time seen, Power, # packets, BSSID, Probed ESSIDs')
                except Exception:
                        stationStart = cleanedDump.index('Station MAC, First time seen, Last time seen, Power, # packets, BSSID, ESSID')
        except Exception:
                print "You Seem to have provided an improper input file please make sure you are loading an airodump txt file and not a pcap"
                sys.exit(1)
        #pdb.set_trace()
        del cleanedDump[stationStart] #Remove the heading line
        clientList = cleanedDump[stationStart:] #Splits all client data into its own list
        del cleanedDump[stationStart:] #The remaining list is all of the AP information
        #apDict = dictCreate(cleanedDump) #Create a dictionary from the list
        #clientDict = dictCreate(clientList) #Create a dictionary from the list
        apDict = apTag(cleanedDump)
        clientDict = clientTag(clientList)
        resultDicts = [clientDict,apDict] #Put both dictionaries into a list
        return resultDicts

def apTag(devices):
        """
        Create a ap dictionary with tags of the data type on an incoming list
        """
        dict = {}
        for entry in devices:
                ap = {}
                string_list = entry.split(',')
                #entry = entry.replace(' ','')
                #sorry for the clusterfuck but i swear it all makse sense
                len(string_list)
                if len(string_list) == 15:
                        ap = {"bssid":string_list[0].replace(' ',''),"fts":string_list[1],"lts":string_list[2],"channel":string_list[3].replace(' ',''),"speed":string_list[4],"privacy":string_list[5].replace(' ',''),"cipher":string_list[6],"auth":string_list[7],"power":string_list[8],"beacons":string_list[9],"iv":string_list[10],"ip":string_list[11],"id":string_list[12],"essid":string_list[13][1:],"key":string_list[14]}
                elif len(string_list) == 11:
                        ap = {"bssid":string_list[0].replace(' ',''),"fts":string_list[1],"lts":string_list[2],"channel":string_list[3].replace(' ',''),"speed":string_list[4],"privacy":string_list[5].replace(' ',''),"power":string_list[6],"beacons":string_list[7],"data":string_list[8],"ip":string_list[9],"essid":string_list[10][1:]}

                if len(ap) != 0:
                        dict[string_list[0]] = ap

def clientTag(devices):
        """
        Create a client dictionary with tags of the data type on an incoming list
        """
        dict = {}
        for entry in devices:
                client = {}
                string_list = entry.split(',')
                if len(string_list) >= 7:
                        client = {"station":string_list[0].replace(' ',''),"fts":string_list[1],"lts":string_list[2],"power":string_list[3],"packets":string_list[4],"bssid":string_list[5].replace(' ',''),"probe":string_list[6:][1:]}
                if len(client) != 0:
                        dict[string_list[0]] = client
        return dict

def usage():
	"""
	Funtion prints out program usage to the user
	"""
	print 'airparse.py \n\t-i "airodump -w file" \n\t-a "toggle this flag if you wish to only show assoicated clients'

def printOutput(input,assoicated):
	"""
	Funtion prints out data from airodump fine in the format of bssid,mac
	"""
	for client in input[0]:  
		#pdb.set_trace()
		if assoicated == True and input[0][client]["bssid"] != "(notassociated)":
			print input[0][client]["bssid"]+","+input[0][client]["station"]
		elif assoicated == False:
			print input[0][client]["bssid"]+","+input[0][client]["station"]


if __name__ == "__main__":
        """
        Main function. Parses command line input for proper switches and arguments. Error checking is done in here.
        Variables are defined and all calls are made from MAIN.
        """
        if len(sys.argv) <= 1:
                usage()
                sys.exit(0)
        parser = optparse.OptionParser("usage: %prog [options] -i input .....")  #read up more on this
	parser.add_option("-i", "--dump", dest="input", nargs=1 ,help="Airodump inputfile")
	parser.add_option("-a", "--assoicated",dest="associated", action="store_true", default=False,help="Help disable showing of non assocated APs") 
	#parser.add_option("-p", "--nopsyco",dest="pysco",action="store_false",default=True,help="Disable the use of Psyco JIT")
	(options, args) = parser.parse_args()
	fileOpenResults = airDumpOpen(options.input)
	parsedResults = airDumpParse(fileOpenResults)
	printOutput(parsedResults,options.associated)
