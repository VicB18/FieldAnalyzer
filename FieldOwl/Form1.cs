using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace FieldOwl
{
    public partial class Form1 : Form
    {

        string[] ImageFileList = new string[10000];
        int ImageFileListN;
        double[] PHI_la;
        double[] Lambda_lo;
        double[] ImageX;
        double[] ImageY;
        double[] ImageT;
        double MapPicBH, MapPicBK;

        public Form1()
        {
            InitializeComponent();
        }

        private void SelectImagesBTN_Click(object sender, EventArgs e)
        {
            DialogResult dr = this.openFileDialog1.ShowDialog();
            if (dr == System.Windows.Forms.DialogResult.OK)
            {
                // Read the files
                foreach (String file in openFileDialog1.FileNames)
                {
                    ImageFileList[ImageFileListN] = file;
                    ImageFileListN++;
                    // Create a PictureBox.
                    try
                    {
                        /*PictureBox pb = new PictureBox();
                        Image loadedImage = Image.FromFile(file);
                        pb.Height = loadedImage.Height;
                        pb.Width = loadedImage.Width;
                        pb.Image = loadedImage;
                        flowLayoutPanel1.Controls.Add(pb);*/
                    }
                    /*catch (SecurityException ex)
                    {
                        // The user lacks appropriate permissions to read files, discover paths, etc.
                        MessageBox.Show("Security error. Please contact your administrator for details.\n\n" +
                            "Error message: " + ex.Message + "\n\n" +
                            "Details (send to Support):\n\n" + ex.StackTrace
                        );
                    }*/
                    catch (Exception ex)
                    {
                        // Could not load the image - probably related to Windows file system permissions.
                        MessageBox.Show("Cannot display the image: " + file.Substring(file.LastIndexOf('\\'))
                            + ". You may not have permission to read the file, or " +
                            "it may be corrupt.\n\nReported error: " + ex.Message);
                    }
                }
            }

            //Reading coordinates
            Thread t = new Thread(new ThreadStart(ReadCoordinates));
            t.Start();

            /*double lo, la;
            for (i = 0; i < ImageFileListN; i++)
            {
                using (Bitmap bitmap = new Bitmap(ImageFileList[i]))
                {
                    lo = GetCoordinateDouble(bitmap.PropertyItems.Single(p => p.Id == 4));
                    la = GetCoordinateDouble(bitmap.PropertyItems.Single(p => p.Id == 2));
                    Lambda_lo[i] = lo / 180 * Math.PI;
                    PHI_la[i] = la / 180 * Math.PI;

                    SetStatusLabelText("Coordinates " + Convert.ToString(i) + " / " + Convert.ToString(ImageFileListN));
                }
            }*/

            //Map creating
            /*
            for (i = 0; i < ImageFileListN; i++)
            {
                ImageX[i] = R * Math.Cos(PHI_la[i]) * (Lambda_lo[i] - Lambda_lo_min);
                ImageY[i] = R * (PHI_la[i] - PHI_la_min);
            }*/
            /*
            Graphics graphics = this.CreateGraphics();
            Pen myPen = new Pen(System.Drawing.Color.Red, 5);
            */
            /*Brush myBrush = new SolidBrush(System.Drawing.Color.Red);
            

            using (var bmp = new Bitmap(MapPicB.Width, MapPicB.Height))
            using (var gfx = Graphics.FromImage(bmp))
            using (var pen = new Pen(Color.White))
            {
                // draw one thousand random white lines on a dark blue background
                gfx.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;
                gfx.Clear(Color.White);
                for ( i = 0; i < ImageFileListN; i++)
                {
                    //var pt1 = new Point((int)X[i], (int)Y[i]);
                    //var pt2 = new Point(rand.Next(bmp.Width), rand.Next(bmp.Height));
                    //gfx.DrawLine(pen, pt1, pt2);
                    gfx.FillEllipse(myBrush, (float)ImageX[i], (float)ImageY[i], 3, 3);
                }

                // copy the bitmap to the picturebox
                MapPicB.Image?.Dispose();
                MapPicB.Image = (Bitmap)bmp.Clone();
            }*/

            /*
            for (i = 0; i < ImageFileListN; i++)
            {
                //MapPicB
                graphics.FillRectangle(myBrush, (float)X[i], (float)Y[i], 1, 1);
                //SetLabelText(Convert.ToString(i) + " / " + Convert.ToString(ImageFileListN));

            }*/

        }

        private void ReadCoordinates()
        {
            double R = 6362132;//[meter]
            int i;
            Lambda_lo = new double[ImageFileListN];
            PHI_la = new double[ImageFileListN];

            double lo, la;
            for (i = 0; i < ImageFileListN; i++)
            {
                using (Bitmap bitmap = new Bitmap(ImageFileList[i]))
                {
                    lo = GetCoordinateDouble(bitmap.PropertyItems.Single(p => p.Id == 4));
                    la = GetCoordinateDouble(bitmap.PropertyItems.Single(p => p.Id == 2));
                    Lambda_lo[i] = lo / 180 * Math.PI;
                    PHI_la[i] = la / 180 * Math.PI;

                    SetStatusLabelText("Coordinates " + Convert.ToString(i) + " / " + Convert.ToString(ImageFileListN));
                }
            }

            //Map creating
            ImageX = new double[ImageFileListN];
            ImageY = new double[ImageFileListN];
            double Lambda_lo_min = Lambda_lo.Min();
            double PHI_la_min = PHI_la.Min();

            for (i = 0; i < ImageFileListN; i++)
            {
                ImageX[i] = R * Math.Cos(PHI_la[i]) * (Lambda_lo[i] - Lambda_lo_min);
                ImageY[i] = R * (PHI_la[i] - PHI_la_min);
            }

            ImageT = new double[ImageFileListN];

            int WindowN = 5;
            int a, b, j, r;
            double[] xValues = new double[WindowN];
            double[] yValues = new double[WindowN];
            double rSquared, intercept, slope;
            /*
            for (i = 0; i < ImageFileListN; i++)
            {
                for (j = 0; j <= WindowN; j++)
                {
                    for(r=0;r< WindowN;r++)
                    {
                        xValues[r] = ImageX[a + r];
                        yValues[r] = ImageY[a + r];
                    }
                    LinearRegression(xValues, yValues, out rSquared, out intercept, out slope);
                }
            }*/

                /*
    WindowN=5; l=2; r=zeros(1,WindowN+1); k=zeros(1,WindowN+1);
    for i=1:N
        for j=1:WindowN+1
            a=max(1,i+j-1-WindowN);
            b=min(N,i+j-1);
            x=X(a:b); y=Y(a:b);
            [b1,k(j),r(j)]=LinRegression(x,y,0,0);
        end
        [r1,j1]=max(r);
        if r1<0.65
            plot(X(i),Y(i),'*r');
        else
            a1=max(1,i+j1-1-WindowN);
            b1=min(N,i+j1-1);
            dx=diff(X(a1:b1));
            dy=diff(Y(a1:b1));
    %         D(i)=sqrt(mean(dx)^2+mean(dy)^2);
    %         if D(i)>10
    %             D(i)=0;
    %         end
            T(i)=atan(k(j1));
            if abs(k(j1))<10 && X(a1)<X(b1)
                T(i)=pi+T(i);
            end
    %         if abs(k(j1))>10 && Y(a1)>Y(b1)
    %             T(i)=pi+T(i);
    %         end
            plot(X(i)+[0 l*cos(T(i))],Y(i)+[0 l*sin(T(i))],'g');
        end
    end             * */

                MapPicBH = MapPicB.Height;
            double MapPicBW = MapPicB.Width;
            double dx = ImageX.Max() - ImageX.Min();
            double dy = ImageY.Max() - ImageY.Min();
            MapPicBK = MapPicBW / dx;
            if (MapPicBK > MapPicBH / dy)
                MapPicBK = MapPicBH / dy;

            DrawMap();
        }

        void DrawMap()
        {
            int i;
            Brush myBrush = new SolidBrush(System.Drawing.Color.Red);

            using (var bmp = new Bitmap(MapPicB.Width, MapPicB.Height))
            using (var gfx = Graphics.FromImage(bmp))
            using (var pen = new Pen(Color.White))
            {
                // draw one thousand random white lines on a dark blue background
                gfx.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;
                gfx.Clear(Color.White);
                for (i = 0; i < ImageFileListN; i++)
                {
                    gfx.FillEllipse(myBrush, (float)(ImageX[i] * MapPicBK), (float)((MapPicBH - ImageY[i] * MapPicBK)), 3, 3);
                }
                MapPicB.Image?.Dispose();
                MapPicB.Image = (Bitmap)bmp.Clone();
            }

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            this.openFileDialog1.Filter =
                "Images (*.BMP;*.JPG;*.GIF)|*.BMP;*.JPG;*.GIF|" +
                "All files (*.*)|*.*";
            this.openFileDialog1.Multiselect = true;
            this.openFileDialog1.Title = "My Image Browser";
        }

        private static double GetCoordinateDouble(PropertyItem propItem)
        {
            uint degreesNumerator = BitConverter.ToUInt32(propItem.Value, 0);
            uint degreesDenominator = BitConverter.ToUInt32(propItem.Value, 4);
            double degrees = degreesNumerator / (double)degreesDenominator;


            uint minutesNumerator = BitConverter.ToUInt32(propItem.Value, 8);
            uint minutesDenominator = BitConverter.ToUInt32(propItem.Value, 12);
            double minutes = minutesNumerator / (double)minutesDenominator;

            uint secondsNumerator = BitConverter.ToUInt32(propItem.Value, 16);
            uint secondsDenominator = BitConverter.ToUInt32(propItem.Value, 20);
            double seconds = secondsNumerator / (double)secondsDenominator;

            double coorditate = degrees + (minutes / 60d) + (seconds / 3600d);
            string gpsRef = System.Text.Encoding.ASCII.GetString(new byte[1] { propItem.Value[0] }); //N, S, E, or W  

            if (gpsRef == "S" || gpsRef == "W")
            {
                coorditate = coorditate * -1;
            }
            return coorditate;
        }

        delegate void SetLabelTextDelegate(string s);
        private void SetStatusLabelText(string s)
        {
            if (this.StatusLabel.InvokeRequired)
            {
                SetLabelTextDelegate d = new SetLabelTextDelegate(SetStatusLabelText);
                this.Invoke(d, new object[] { s });
            }
            else
            {
                StatusLabel.Text = s;
            }
        }

        public static void LinearRegression(double[] xVals, double[] yVals, out double rSquared, out double yIntercept, out double slope)
        {
            if (xVals.Length != yVals.Length)
            {
                throw new Exception("Input values should be with the same length.");
            }

            double sumOfX = 0;
            double sumOfY = 0;
            double sumOfXSq = 0;
            double sumOfYSq = 0;
            double sumCodeviates = 0;

            for (var i = 0; i < xVals.Length; i++)
            {
                var x = xVals[i];
                var y = yVals[i];
                sumCodeviates += x * y;
                sumOfX += x;
                sumOfY += y;
                sumOfXSq += x * x;
                sumOfYSq += y * y;
            }

            var count = xVals.Length;
            var ssX = sumOfXSq - ((sumOfX * sumOfX) / count);
            var ssY = sumOfYSq - ((sumOfY * sumOfY) / count);

            var rNumerator = (count * sumCodeviates) - (sumOfX * sumOfY);
            var rDenom = (count * sumOfXSq - (sumOfX * sumOfX)) * (count * sumOfYSq - (sumOfY * sumOfY));
            var sCo = sumCodeviates - ((sumOfX * sumOfY) / count);

            var meanX = sumOfX / count;
            var meanY = sumOfY / count;
            var dblR = rNumerator / Math.Sqrt(rDenom);

            rSquared = dblR * dblR;
            yIntercept = meanY - ((sCo / ssX) * meanX);
            slope = sCo / ssX;
        }








    }
}
