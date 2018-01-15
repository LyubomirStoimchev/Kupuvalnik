using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;

namespace KupuvalnikWeb {
    public class MailSender {


        public static string SendMail(string custName, string custEmail, string itemName, string totalPrice)
        {
            string mailBody = CreateHTMLBody(custName, itemName, totalPrice);
            string mailSubject = "Item " + itemName + " have been sent to you!";

            SmtpClient client = new SmtpClient("cchsmtp.eur.cchbc.com");
            client.Port = 25;

            MailMessage msg = new MailMessage();
            msg.From = new MailAddress("Kupuvalnik@cchellenic.com");
            msg.To.Add(custEmail);
            msg.IsBodyHtml = true;
            msg.Subject = mailSubject;
            msg.Body = mailBody;
            client.Timeout = 3000;

            try
            {
                client.Send(msg);

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return "fail";

            }
            

            client.Dispose();
            msg.Dispose();
            return "pass";
        }

        private static string CreateHTMLBody(string custName, string itemName, string totalPrice)
        {
            string s = "";
            s += "<html>" + Environment.NewLine;
            s += "<head>" + Environment.NewLine;
            s += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"></head>" + Environment.NewLine;
            s += "<body> Dear " + custName + "," + Environment.NewLine;
            s += "<p>Thank you for your purchase!" + Environment.NewLine;
            s += "<p>Item: " + itemName  + " has been sent to your address. Total price is " + totalPrice + " leva." + Environment.NewLine;
            s += "<p>" + Environment.NewLine;
            s += "<p>Kupuvalnik" + Environment.NewLine;    
            s += "</body>" + Environment.NewLine;
            s += "</html>" + Environment.NewLine;

            return s;
        }
    }
}