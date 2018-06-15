#include<iostream>
#include<cstdlib>
#include<fstream>
#include "LCD.c"
using namespace std;

int main(void){
	ofstream ofile("LCD.v",ios::out);
	if(ofile.is_open()){
		ofile <<"module lcd_rom("<< endl;
		//ofile <<"\tinput ck,"<< endl;
		ofile <<"\tinput [9:0] address,"<< endl;
		ofile <<"\toutput [7:0] data_out"<< endl;
		ofile <<");"<< endl;
		ofile <<"reg [7:0]rom[1023:0];"<< endl;
		ofile <<"assign data_out = rom[address];"<< endl;
		ofile <<"initial"<< endl;
		ofile <<"begin"<< endl;
		//ofile <<"\tcase(address)"<< endl;
		//
		cout <<"module lcd_rom("<< endl;
		//cout <<"\tinput ck,"<< endl;
		cout <<"\tinput [9:0] address,"<< endl;
		cout <<"\toutput [7:0] data_out"<< endl;
		cout <<");"<< endl;
		cout <<"reg [7:0]rom[1023:0];"<< endl;
		cout <<"assign data_out = rom[address];"<< endl;
		cout <<"initial"<< endl;
		cout <<"begin"<< endl;
		//cout <<"\tcase(address)"<< endl;
		for(int i=0;i<1024;i++){
			ofile << "\t\trom[" << dec << i << ((i<1000)? "]   \t" : "]\t") << "<= 8'h" << hex << int(gImage_LCD[i]) << ";" << endl;
			cout << "\t\trom[" << dec << i << ((i<1000)? "]   \t" : "]\t") << "<= 8'h" << hex << int(gImage_LCD[i]) << ";" << endl;
		}
		//ofile <<"\tendcase"<< endl;
		ofile <<"end"<< endl;
		ofile <<"\nendmodule"<< endl;
		//
		//cout <<"\tendcase"<< endl;
		cout <<"end"<< endl;
		cout <<"\nendmodule"<< endl;
		//--------------------------------
		printf("OK\n");
	}
	else{
		printf("ERROR\n");
	}
	ofile.close();
	
	system("pause");
	return 0;
}

