using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO.Ports;
using System.Web.Services;
using System.Web.Script.Services;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace Lora
{
    public class Gps
    {
        public decimal lat { get; set; }
        public decimal lng { get; set; }
        public int no { get; set; }

        public Gps(decimal Lat, decimal Lng, int No)
        {
            lat = Lat;
            lng = Lng;
            no = No;
        }

    }

    public partial class MAP : Page
    {
        private static SerialPort serialPort1;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) // 第一次讀取
            {
                string[] portname = SerialPort.GetPortNames();
                // this.DropDownList1.DataSource = portname;
                // this.DropDownList1.DataBind();
            }
        }

        private static void Save2Database(string data)
        {
            string[] dataList = data.Split(',');

            SqlConnection conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            conn.Open();
            SqlTransaction transaction = conn.BeginTransaction();
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = conn;
            cmd.CommandText = "INSERT INTO [Table] (lat, lng, dis, no) VALUES (@lat, @lng, @dis, @no)";
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("lat", float.Parse(dataList[0]));
            cmd.Parameters.AddWithValue("lng", float.Parse(dataList[1]));
            cmd.Parameters.AddWithValue("dis", float.Parse(dataList[2]));
            cmd.Parameters.AddWithValue("no", int.Parse(dataList[3]));
            cmd.Transaction = transaction;
            try
            {
                cmd.ExecuteNonQuery();
                transaction.Commit();
            }
            catch
            {
                transaction.Rollback();
            }
            finally
            {
                conn.Close();
            }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(UseHttpGet = true)]

        public static string HelloWorld()
        {
            serialPort1 = new SerialPort()
            {
                PortName = "COM3",
                BaudRate = 115200,
                Parity = Parity.None,
                DataBits = 8,
                StopBits = StopBits.One
            };
            serialPort1.Open();

            if (serialPort1.IsOpen)
            {
                string data = serialPort1.ReadLine();
                Save2Database(data);
                serialPort1.Close();
                return data;
            }
            else
            {
                return "err";
            }
        }

        [WebMethod(EnableSession = true)]
        //[ScriptMethod(UseHttpGet = true)]

        public static List<Gps> history(int id)
        {
            SqlConnection conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            conn.Open();
            string strSQL = "SELECT TOP 125 * FROM [Table] WHERE no = " +id +"ORDER BY Id DESC";
            SqlCommand myCommand = new SqlCommand(strSQL, conn);
            SqlDataReader data = myCommand.ExecuteReader();

            List<Gps> x = new List<Gps> ();
            List<string> y = new List<string>();

            while(data.Read())
            {
                x.Add(new Gps ( Convert.ToDecimal(data["lat"]), Convert.ToDecimal(data["lng"]), Convert.ToInt32(data["no"])));
            }
            return x;
        }
    }
}