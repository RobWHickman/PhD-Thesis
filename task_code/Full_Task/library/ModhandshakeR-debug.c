#include "mex.h"
#include "time.h"
#include "matrix.h"
#include "stdio.h"

#include <C:\MATLAB\GettyM1.0\test\NIDAQmx.h>


int handshake(double badshake[], double floataddvals[], int ncols)
{    
	TaskHandle  dinfooutadr=0;
    TaskHandle  hardtrigout=0;
    TaskHandle  handshakeout=0;
    TaskHandle  dinfoinadr=0;
    TaskHandle  handshakein=0;
    
    uInt8       input[8];
    int         intinput=0;
    uInt8       output[8];
    uInt8       shakein[1];
    uInt8       hardout[1];
    uInt8       shakeout[1];
    int32       *sampsin;
    int32       *bytesin;
    int32       *sampsout;
    double      *abort;
    int8        *addvar=calloc(ncols, sizeof(int8));
    
    int         n=0, i=0;
    mxArray     *breakkey;
    
    for (i=0;i<ncols;i++){
        addvar[i]=(int)floataddvals[i];
    }
        
    badshake[0]=0;
    breakkey =  mxCreateDoubleMatrix(1,1, mxREAL);

    DAQmxCreateTask("",&dinfooutadr);
	DAQmxCreateDOChan(dinfooutadr,"Dev1/port0/line24:31","",DAQmx_Val_ChanPerLine);
        
	DAQmxCreateTask("",&hardtrigout);
	DAQmxCreateDOChan(hardtrigout,"Dev1/port0/line22","",DAQmx_Val_ChanPerLine);

	DAQmxCreateTask("",&handshakeout);
	DAQmxCreateDOChan(handshakeout,"Dev1/port0/line23","",DAQmx_Val_ChanPerLine);
    
    DAQmxCreateTask("",&dinfoinadr);
	DAQmxCreateDIChan(dinfoinadr,"Dev1/port2/line0:7","",DAQmx_Val_ChanPerLine);
    
 	DAQmxCreateTask("",&handshakein);
	DAQmxCreateDIChan(handshakein,"Dev1/port1/line7","",DAQmx_Val_ChanPerLine);
    
    //start by zeroing handshake and hardtrigger
	hardout[0]=0;
    shakeout[0]=0;
    DAQmxWriteDigitalLines (hardtrigout, 1, 1 , -1, DAQmx_Val_GroupByScanNumber, hardout, &sampsout, NULL);
    DAQmxWriteDigitalLines (handshakeout, 1, 1 , -1, DAQmx_Val_GroupByScanNumber, shakeout, &sampsout, NULL);

    
    
    //is Getty here, Getty sends 252. (this for old Getty).
    DAQmxReadDigitalLines(dinfoinadr,1,-1,DAQmx_Val_GroupByChannel,input,8,&sampsin,&bytesin,NULL);
    intinput=(input[7]<<7)|(input[6]<<6)|(input[5]<<5)|(input[4]<<4)|(input[3]<<3)|(input[2]<<2)|(input[1]<<1)|input[0];
    if (intinput!=252){
        badshake[0]=1;
        //printf("Getty not running or not connected\n");
        //printf("Read %d from Getty\n", intinput);
        return;
    }
    printf("71 seen Getty\n");
    //hardout[0]=0;
	//DAQmxWriteDigitalLines (hardtrigout, 1, 1 , -1, DAQmx_Val_GroupByScanNumber, hardout, &sampsout, NULL);

    n=0;
    while (n==0){
        //is handshake up
        DAQmxReadDigitalLines(handshakein,1,-1,DAQmx_Val_GroupByChannel,shakein,1,&sampsin,&bytesin,NULL);
        if (shakein[0]==1){
            printf("80 seen shake up\n");
            break;
        }
        
        //if x is pressed then break.
        mexCallMATLAB(1,&breakkey,0, NULL, "press");
        abort=mxGetPr(breakkey);
        if (abort[0]==1){
            badshake[0]=2;
            return;
        }               
    }
    
    hardout[0]=1;
    //shakeout[0]=0;
    printf("95 set shake up\n");
    DAQmxWriteDigitalLines (hardtrigout, 1, 1 , -1, DAQmx_Val_GroupByScanNumber, hardout, &sampsout, NULL);
    //DAQmxWriteDigitalLines (handshakeout, 1, 1 , -1, DAQmx_Val_GroupByScanNumber, shakeout, &sampsout, NULL);
    
    n=0;
    while (n==0){
        
        //is handshake down
        DAQmxReadDigitalLines(handshakein,1,-1,DAQmx_Val_GroupByChannel,shakein,1,&sampsin,&bytesin,NULL);

        if (shakein[0]==0){
            printf("106 seen shake down\n");
            break;
        }
        
        //if x is pressed then break.
        mexCallMATLAB(1,&breakkey,0, NULL, "press");
        abort=mxGetPr(breakkey);
        if (abort[0]==1){
            badshake[0]=3;
            return;
        }     
        
        //is Getty here, Getty sends 252. (this for old Getty).
//         DAQmxReadDigitalLines(dinfoinadr,1,-1,DAQmx_Val_GroupByChannel,input,8,&sampsin,&bytesin,NULL);
//         intinput=(input[7]<<7)&(input[6]<<6)&(input[5]<<5)&(input[4]<<4)&(input[3]<<3)&(input[2]<<2)&(input[1]<<1)&input[0];
//         if (intinput!=252){
//             badshake[0]=1;
//             printf("Getty not running or not connected\n");
//             printf("Read %d from Getty\n", intinput);
//             return;
//         }

    }
   
    hardout[0]=0;
    DAQmxWriteDigitalLines (hardtrigout, 1, 1 , -1, DAQmx_Val_GroupByScanNumber, hardout, &sampsout, NULL);
    

    for (i=0;i<addvar[0];i++){
        //printf("%d ",addvar[i]);
        for (n=0;n<8;n++){
            //output[n]=addvar[i]&(1<<n);
            if ((addvar[i]&(1<<n))==0){
                output[n]=0;
            }
            else{
                output[n]=1;
            }
        }
        printf("145 sending addvar\n");
        DAQmxWriteDigitalLines (dinfooutadr, 1, 1 , -1, DAQmx_Val_GroupByScanNumber, output, &sampsout, NULL);
        

        shakeout[0]=1;
        DAQmxWriteDigitalLines (handshakeout, 1, 1 , -1, DAQmx_Val_GroupByScanNumber, shakeout, &sampsout, NULL);

        n=0;
        while (n==0){
            //is handshake up
            DAQmxReadDigitalLines(handshakein,1,-1,DAQmx_Val_GroupByChannel,shakein,1,&sampsin,&bytesin,NULL);
            if (shakein[0]==1){
                printf("157 seen shake up\n");
                break;
            }
                    
            //if x is pressed then break.
            mexCallMATLAB(1,&breakkey,0, NULL, "press");
            abort=mxGetPr(breakkey);
            if (abort[0]==1){
                badshake[0]=4;
                return;
            }
            
            //is Getty here, Getty sends 252. (this for old Getty).
//             DAQmxReadDigitalLines(dinfoinadr,1,-1,DAQmx_Val_GroupByChannel,input,8,&sampsin,&bytesin,NULL);
//             intinput=(input[7]<<7)&(input[6]<<6)&(input[5]<<5)&(input[4]<<4)&(input[3]<<3)&(input[2]<<2)&(input[1]<<1)&input[0];
//             if (intinput!=252){
//                 badshake[0]=1;
//                 printf("Getty not running or not connected\n");
//                 printf("Read %d from Getty\n", intinput);
//                 return;
//             }
        }

      
        hardout[0]=1;
        shakeout[0]=0;
        DAQmxWriteDigitalLines (hardtrigout, 1, 1 , -1, DAQmx_Val_GroupByScanNumber, hardout, &sampsout, NULL);
        DAQmxWriteDigitalLines (handshakeout, 1, 1 , -1, DAQmx_Val_GroupByScanNumber, shakeout, &sampsout, NULL);
              
        while (n==0){
            //is handshake down
            DAQmxReadDigitalLines(handshakein,1,-1,DAQmx_Val_GroupByChannel,shakein,1,&sampsin,&bytesin,NULL);

            if (shakein[0]==0){
                printf("191 shake down\n");
                break;
            }
                    
            //if x is pressed then break.
            mexCallMATLAB(1,&breakkey,0, NULL, "press");
            abort=mxGetPr(breakkey);
            if (abort[0]==1){
                badshake[0]=5;
                return;
            } 
            
            //is Getty here, Getty sends 252. (this for old Getty).
//             DAQmxReadDigitalLines(dinfoinadr,1,-1,DAQmx_Val_GroupByChannel,input,8,&sampsin,&bytesin,NULL);
//             intinput=(input[7]<<7)&(input[6]<<6)&(input[5]<<5)&(input[4]<<4)&(input[3]<<3)&(input[2]<<2)&(input[1]<<1)&input[0];
//             if (intinput!=252){
//                 badshake[0]=1;
//                 printf("Getty not running or not connected\n");
//                 printf("Read %d from Getty\n", intinput);
//                 return;
//             }
        }
    }
    //reset
    
    hardout[0]=0;
    printf("217 set hard off\n");
    DAQmxWriteDigitalLines (hardtrigout, 1, 1 , -1, DAQmx_Val_GroupByScanNumber, hardout, &sampsout, NULL);

    
	for (n=0;n<8;n++){
        output[n]=0;
    }

    DAQmxClearTask (dinfooutadr);
    DAQmxClearTask(hardtrigout);
    DAQmxClearTask (handshakeout);
    DAQmxClearTask (dinfoinadr);
    DAQmxClearTask (handshakein);
    free(addvar);
    
    //printf("\n");

}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs,
                 const mxArray *prhs[])
{  
    double *badshake;
    double *y;
    int     status,mrows,ncols;


    /*  create a pointer to the input matrix y */
    y = mxGetPr(prhs[0]);
    
    //addvals=(int)y;

    /*  get the dimensions of the matrix input y */
    mrows = mxGetM(prhs[0]);
    ncols = mxGetN(prhs[0]);
  
    plhs[0] = mxCreateDoubleMatrix(1,1, mxREAL);
  
    badshake = mxGetPr(plhs[0]);
    //badshake 1=no Getty; badshake 0=handshake worked; badshake 3,4,5=Getty present, handshake failed.

    handshake(badshake, y, ncols);
}