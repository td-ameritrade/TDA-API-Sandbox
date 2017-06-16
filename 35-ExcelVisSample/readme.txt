1) Make sure to register the TDAACTX.OCX before using the Excel Sample

For example, if the OCX is in the C:\TDA-API\ActiveX  folder, then to manually register the OCX, you would Run the following command:

REGSVR32  C:\TDA-API\ActiveX\TDAACTX.OCX

NOTE: If this is done for an UPDATE - if you already had TDAACTX.OCX registered previously and used it in Excel, you will need to delete the caching info that Excel keeps. To do that, delete the TDAAX.EXD file in the Temp folder, Excel sub-folder. If doing it from the command prompt, type:

CD %TMP%
then do a DIR and look for Excel folders. It may be "Excel8.0" for example, or just Excel. Then go to that folder and delete the TDAACTX.EXD file.

Until you do that, Excel will not see the change, even if the new OCX is registered

2) Make sure to specify your SOURCE ID in the VBA code. You will find it in the very beginning of the code, in the TDAComm1_OnStatusChange event handler