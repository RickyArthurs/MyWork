import javax.swing.JDialog;
import javax.swing.JOptionPane;
import java.io.*;
import java.util.ArrayList;

public class RENT
{
    private String NameRent;
    private int Rent;
    private int OneHouse;
    private int TwoHouse;
    private int ThreeHouse;
    private int FourHouse;
    private int Hotel;
    

    
    public RENT()
    {
        NameRent = "";
        Rent = 0;
        OneHouse = 0;
        TwoHouse = 0;
        ThreeHouse = 0;
        FourHouse = 0;
        Hotel = 0;
        
    }

    
    public void readDetails1(String rowItems1[])
    {
     NameRent = (rowItems1[0]);
     Rent = Integer.parseInt(rowItems1[1]);
     OneHouse = Integer.parseInt((rowItems1[2]));
     TwoHouse = Integer.parseInt((rowItems1[3]));
     ThreeHouse = Integer.parseInt((rowItems1[4]));
     FourHouse = Integer.parseInt((rowItems1[5]));
     Hotel = Integer.parseInt((rowItems1[6]));
     
    }
    
    public String getRentName()
    {
     return NameRent;   
    }
    
    public int getRent()
    {
     return Rent;   
    }
    
    public int getOneHouse()
    {
     return OneHouse;   
    }
    
    public int getTwoHouse()
    {
     return TwoHouse;   
    }
    
    public int getThreeHouse()
    {
     return ThreeHouse;   
    }
    
    public int getFourHouse()
    {
     return FourHouse;   
    }
    
    public int getHotel()
    {
     return Hotel;   
    }
    
    
}
