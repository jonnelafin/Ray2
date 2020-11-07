class mapC2{
    boolean supressHex = false;
    String m(String thing, int times){
        return new String(new char[times]).replace("\0", thing);
    }
    //Generate empty data
    boolean[][] genDat(int subdiv){
        boolean dat[][] = new boolean[subdiv][subdiv];
        for(int i=0;i<subdiv;i++){
            for(int z=0;z<subdiv;z++){
                dat[i][z] = false;
            }
        }
        return dat;
    }
    //Data from save, please remember to substract one from w before giving it here
    boolean[][] dataFromPacked(String val, int w, int fsiz){
        boolean dat[][] = new boolean[fsiz][fsiz];
        
        int ind = 0;
        int x = -1;
        int y = 0;
        String buff = "";
        int aind = 0;
        
        String bin = toBin(val, fsiz);
        for(char c : bin.toCharArray()){
            if(ind > w){
                ind = 0;
                x = 0;
                y += 1;
                buff = "";
            }
            else if(aind + 2 > fsiz){
                x += 1;
                dat[x][y] = (bin.charAt(aind) == '1');
                buff += bin.charAt(aind);
            }
            else{
                x++;
            }
            buff += 1;
            ind += 1;
            aind += 1;
            dat[x][y] = (c == '1');
        }
        return dat;
    }
    //Int/hex to bin
    String toBin(String val, int original){
        String val2 = val;
        if (val.contains("0x")){
           val2 = Integer.parseInt(val2.replace("0x",""), 16) + ""; 
        }
        String bin = Integer.toBinaryString(Integer.parseInt(val2));
        if (bin.length() < original){
            bin = m("0",(original-bin.length())) + bin; //"0"*(original-bin.length())
        }
        return bin;
    }  
    String toBin(String val){
        return toBin(val, -1);
    }
    //Bin to int/hex
    String toInt(String val, boolean doHex/*=True*/){
        int intVal = Integer.parseInt(val, 2);
        if(doHex){
            if(intVal < 2147483646){ //Max hex value
                return ("0x" + Integer.toHexString(intVal));
            }
            if(!supressHex){
                print("Value is over the max hex value. Int will be used instead. This warning will be supressed on future uses of the function.");
                supressHex = true;
            }
        }
        return intVal + "";
    }
    String toInt(String val){
        return toInt(val, false);
    }
    //Parses the map to a printable format
    String parseMap(String val, int wsize, int fsize){
        String out = "";
        int ind = 0;
        for(char c : toBin(val, fsize).toCharArray()){
            if(ind > wsize){
                out += "\n";
                ind = 0;
            }
            ind++;
            out += c;
        }
        return out;
    }
    //Packs the values into a single string
    String pack(String data, int wsize, int fsize){
        return wsize + "#" + data + "#" + fsize;
    }
    //Integer from string
    int sToInt(String val){
        if(val.contains("0x")){
            return Integer.parseInt(val.replace("0x",""), 16); 
        }
        return Integer.parseInt(val);
    }
    //Unpacking: data
    String unpack_d(String packd){
        return packd.split("#")[1].split("#")[0].replace("#", "");
    }
    //Unpacking: wsize
    int unpack_w(String packd){
        return sToInt(packd.split("#")[0].replace("#", ""));
    }
    //Unpacking: fsize
    int unpack_f(String packd){
        return sToInt(packd.split("#")[2].replace("#", ""));
    }
    
    //Data from packed
    
    //String toBin(String val, int original){
    //    String bin = "";
    //    if(val == "" || val == "None"){
    //        val = "0";
    //    }
    //    if(val.contains("0x") && int(val, 0) < 2147483646){ //Max hex value
    //        bin = format(int(val, 0), "08b");
    //    }
    //    else{
    //        bin = format(int(val), "08b");
    //    }
    //    if (bin.length() < original){
    //        bin = m("0",(original-bin.length())) + bin; //"0"*(original-bin.length())
    //    }
    //    return bin;
    //}
}
