#include <iostream>
#include <cstdio>
#include <fstream>
#include <cstring>
#include <string> // For:string class
//#include <strstream>
//#include <stdlib>
#include <ctime>

#define TEST 1
#define TSTRING 0

#if (TSTRING == 1)
#include <sstream>
#endif
using namespace std;

int READ_FILE = 0;
class date {
  int day, month, year;
#if (TSTRING == 1 )
  string str;
#else
  char str[80];
#endif

public:
  //  date(char *str)
  date(time_t t);

  string show() {
#if ( TSTRING == 1)
    //    sprintf(str,"%d%d%d",year , month , day);
    //    str<< year;// , month , day;
    str = year, month , day;
    //    return str.str();
    return str;
    //    return str + ".dot";
#else
    sprintf(str,"%d%d%d",year , month , day);
    return str;
#endif
  }
  //  operator char *() {return year , month , day;}
#if TSTRING == 1
  operator string() {return str; };
#else
  operator char *() {return str; };
#endif
};

date::date(time_t t)
{
  struct tm *p;

  p = localtime(&t);
  day = p->tm_mday;
  month = p->tm_mon;
  year = p->tm_year;
}

/*
  string numtostring(int number)
  {
  string stream ss;
  ss << number;
  return ss.str();
  }
*/

int main() {
  string ans;    
  int num;
  string confName, fname;
  date ffname(time(NULL));

  //read in manual configuration file.
  cout << "Do you want to read in configuration file you prepared?[y/n]";
  cin >> ans;

  ifstream fin;
  if ( ans == "y" ) {
    READ_FILE = 1;
    cout << "Type file name you want to read into.[absolute or relative file name]";
    cin >> confName;
    //	ifstream fin(confName.c_str);
    fin.open(confName.c_str(), ios::in);
    //	fin.open(confName.c_str);
    if(!fin) {
      cout << confName << "open error";
      return(1);
    }
  }
  cout << "What do you want to name the output file?\n";
  cout << " "<< "[default value:" << confName << ".dot]. Just hit [Enter] if you choose default." << endl;
  cout << " "<< "Enter '1' if you want to name " << ffname.show() << ".dot";
  //    cout << "[default value:" << ffname.show() << ".dot]. Just hit [Enter] if you choose default." << endl;
  cin.ignore(1000,'\n');
  getline(cin,fname);

  if( fname == "" ) {
    //  cout << fname << "Receive [Enter] working.";
    fname =  confName;
  } else if ( fname == "1")
    fname = ffname.show();

  ofstream fout;
  //  fout.open(fname.c_str());
  fout.open((fname + ".dot" ).c_str());
  //  fout.open(fname);
  if(!fout.is_open()) {
    cout <<"file open error\n";
    return 1;
  }
  fout << "digraph " << fname.c_str() << " {\n";

  char ch;
  int to,from;
  to = from = 1;
  //#if TEST == 1
  while(fin.get(ch)) {
    //	  cout << ch;
    //	while((ch = getc(fin)) != EOF) { 
    //#else
    /*
      while(!fin.eof()) {
      fin >> ch;
    */
    //#endif
    switch( ch ) {
    case '+':
      fout << from << " -> " << to << " [color = red ];\n";
      break;
    case '-':
      fout << from << " -> " << to << " [color = blue];\n";
      break;
    case '0':
      //	    cout << from << " -> " << to << "\n";
      break;
    case '\n':
      //	    cout << "read '\n'";
      to += 1;
      from = 0;
      break;
    default:
      //error hundling
      cout << "default"<< from << " -> " << to << "\n";
      break;
    }
    from += 1;
  }
  fout << "}" << endl;
  fin.close();
  //      }

// ++bug
  if ( READ_FILE == 0 ) {
    cout << "How many neurons do you simulate? ";
    cin >> num;
    // get num.neuron
    // default to self-connect
    cout << "self-connect all nerurons? :[y/n]" << flush;
    cin >> ans;
    //graphviz
    for(int i1=0; i1 <num; i1++) {
      for(int i2=0; i2 <num; i2++) {
	cout << i2 << " -> " << i1 << " ?\n [+/-/0]" << flush;
	cin >> ans;
	fout << ans;
      }
      fout << "\n";
    }
    fout << "}" << endl;
  } else { 
    //// convert +/-/0 file to graphviz format
  }	

  fout.close();

  //    cout << " dot -Tpng" << ffname.show() << " .dot -o " << ffname.show() << ".png " << endl;
  string ostr;
  ostr = " dot -Tpng "+ fname +  ".dot -o " + fname + ".png ";
  system(ostr.c_str());

  return 0;
}

// output profile

// $ dot -Tpng *.dot -o *.png
//system(" dot -Tpng *.dot -o *.png ");
//cout << " dot -Tpng"<< fname.c_str()<< " .dot -o "<< fname.c_str()<< ".png ";
//      system(" dot -Tpng", fname.c_str(), " .dot -o ", fname.c_str(), ".png ");


// output connection +/-/0 into terminal.
