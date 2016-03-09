#include <stdio.h>
#include <assert.h>
#include <fstream>
#include <sstream>
#include <iostream>
#include <limits.h>
#include <vector>

using namespace std;

typedef struct JoystickData {

    int timestamp;
    double forward_backward;
    double left_right;

} JoystickData;

int main() {

   FILE *fp;
   char buff[255];

   fp = fopen("/home/lili/Journal/Joy.txt", "r");
   assert(fp);

   /*
   header:
  seq: 5638
  stamp:
    secs: 1457498463
    nsecs: 196412897
  frame_id: chair_joy
axes: [0.0, 0.0]
buttons: []
---
   */

   vector<JoystickData> joystickVec;


   ofstream fout("/home/lili/Journal/JoyAndTime.txt");

   int i=0;
   char line[100];
   while(!feof(fp))
  {
       JoystickData data;
       char header[1024] = {NULL};
       char seq_s[1024] = {NULL};
       int seq = 0;
       char stamp_s[1024] = {NULL};
       char secs_s[1024] = {NULL};
       int secs = 0;
       char nsecs_s[1024] = {NULL};
       int nsecs = 0;
       char frame_id[1024] = {NULL};
       char chair_joy[1024] = {NULL};
       char axes[1024] = {NULL};

       char coordinate1[1024]={NULL};
       char coordinate2[1024]={NULL};
       char buttons[1024] = {NULL};
       char braces[1024]={NULL};
       char part[1024] = {NULL};

       double forward_backward = 0.0;
       double left_right = 0.0;

        fscanf(fp, "%s", header);
        fscanf(fp, "%s %d", seq_s, &seq);
        fscanf(fp, "%s", stamp_s);
        fscanf(fp, "%s", secs_s);
        fscanf(fp, "%d", &data.timestamp);
        fscanf(fp, "%s", nsecs_s);
        fscanf(fp, "%d", &nsecs);
        fscanf(fp, "%s", frame_id);
        fscanf(fp, "%s", chair_joy);
       // printf("%s \n", chair_joy);
        fscanf(fp, "%s", axes);
       // printf("%s \n", axes);
        fscanf(fp, "%f", &data.forward_backward);
       // printf("%f \n", data.forward_backward);
        fscanf(fp, "%f", &data.left_right);
        //printf("%f\n", data.left_right);

       // printf("%f\n", data.left_right);
        fscanf(fp, "%s %s", coordinate1, coordinate2);

        printf("%s %s\n ", coordinate1, coordinate2 );

        fscanf(fp, "%s %s", buttons, braces);
        fscanf(fp, "%s", part);
       // printf("%s",part);

        string coord1=string(coordinate1);
        string coord2=string(coordinate2);

        for(int m=0; m<coord1.size(); m++)
        {
            if(coord1[m] == '[')
            {
                coord1.erase(m,1);
            }
        }

        for(int n=0; n<coord2.size(); n++)
        {
            if(coord2[n] == ']')
            {
                coord2.erase(n,1);
            }
        }

        fout<<data.timestamp<<"   "<<coord1<<"   "<<coord2<<endl;
        joystickVec.push_back(data);

        i++;
   }

    cout<<joystickVec.size()<<endl;

   fclose(fp);

   return 0;
}
