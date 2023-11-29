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
using System.Drawing.Drawing2D;
using System.IO;

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
        double[] ImageDir;
        double[] ImageScaleK;
        double MapPicBH, MapPicBK;
        double Drone4m = 570;//[pix/meter]626
        double MapPix_Meter = 50;

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
                    catch (Exception ex)
                    {
                        // Could not load the image - probably related to Windows file system permissions.
                        MessageBox.Show("Cannot display the image: " + file.Substring(file.LastIndexOf('\\'))
                            + ". You may not have permission to read the file, or " +
                            "it may be corrupt.\n\nReported error: " + ex.Message);
                    }
                }
            }

            Thread t = new Thread(new ThreadStart(MapAssembling));
            t.Start();
        }

        private void MapAssembling()
        {
            double R = 6362132;//[meter]
            int i, j;
            Lambda_lo = new double[ImageFileListN];
            PHI_la = new double[ImageFileListN];
            Color pixelColor;
            int RowN;
            int[,] RowList;

            double lo, la;
            for (i = 0; i < ImageFileListN; i++)
            {
                using (Bitmap bitmap = new Bitmap(ImageFileList[i]))
                {
                    lo = GetCoordinateDouble(bitmap.PropertyItems.Single(p => p.Id == 4));
                    la = GetCoordinateDouble(bitmap.PropertyItems.Single(p => p.Id == 2));
                    Lambda_lo[i] = lo;
                    PHI_la[i] = la;
                    SetStatusLabelText("Coordinates " + Convert.ToString(i) + " / " + Convert.ToString(ImageFileListN));
                }
            }

            ImageX = new double[ImageFileListN];
            ImageY = new double[ImageFileListN];
            //double loOffs = Lambda_lo.Min();
            //double laOffs = PHI_la.Min();
            double loOffs = 22.662751;
            double laOffs = 60.401937;

            for (i = 0; i < ImageFileListN; i++)
            {
                ImageX[i] = R * Math.Cos(PHI_la[i] / 180 * Math.PI) * (Lambda_lo[i] - loOffs) / 180 * Math.PI;
                ImageY[i] = R * (PHI_la[i] - laOffs) / 180 * Math.PI;
            }

            FindLinesInScanningTrajectory(ImageX, ImageY, out RowN, out RowList);

            ImageDir = new double[ImageFileListN];
            ImageScaleK = new double[ImageFileListN];
            double[] x1, y1;
            double rSquared, yIntercept, slope, RMSE;

            for (i = 0; i < RowN; i++)
            {
                x1 = new double[RowList[i, 1] - RowList[i, 0] + 1];
                y1 = new double[RowList[i, 1] - RowList[i, 0] + 1];
                for (j = RowList[i, 0]; j <= RowList[i, 1]; j++)
                {
                    x1[j - RowList[i, 0]] = ImageX[j];
                    y1[j - RowList[i, 0]] = ImageY[j];
                }
                LinearRegression(x1, y1, out rSquared, out yIntercept, out slope, out RMSE);

                if(Math.Abs(Math.Atan(slope))<45.0 / 180 * Math.PI)
                {
                    if(ImageX[RowList[i, 0]] > ImageX[RowList[i, 1]])
                        for (j = RowList[i, 0]; j <= RowList[i, 1]; j++)
                            ImageDir[j] = Math.Atan(slope)+ Math.PI/2;
                    else
                        for (j = RowList[i, 0]; j <= RowList[i, 1]; j++)
                            ImageDir[j] = Math.Atan(slope) - Math.PI / 2;
                }
                for (j = RowList[i, 0]; j <= RowList[i, 1]; j++)
                    ImageScaleK[j] = Drone4m;
            }
            /*
            for i = 1:RowN
    [b, k] = LinRegression(X(RowList(i, 1):RowList(i, 2)), Y(RowList(i, 1):RowList(i, 2)), 0, 0);
        if abs(atan(k)) < 45 / 180 * pi
            if X(RowList(i, 1)) > X(RowList(i, 2))
                ImageDir(RowList(i, 1):RowList(i, 2)) = atan(k) + pi / 2;
                    else
                        ImageDir(RowList(i, 1):RowList(i, 2)) = atan(k) - pi / 2;
            end
        end
        ImageScaleK(RowList(i, 1):RowList(i, 2)) = Drone4m;
            end
                */

                    Image A;
            A = Image.FromFile(ImageFileList[0]);
            double ImageRp = Math.Sqrt(A.Width * A.Width + A.Height * A.Height) / 2 / ImageScaleK[0] * MapPix_Meter;
            double MapDx = ImageX.Max() - ImageX.Min() + 2 * ImageRp / MapPix_Meter;
            double MapDy = ImageY.Max() - ImageY.Min() + 2 * ImageRp / MapPix_Meter;
            double MinX = ImageX.Min() * MapPix_Meter - 0 * ImageRp;
            int MaxY = Convert.ToInt32(MapDy * MapPix_Meter - 2 * ImageRp);
            double ImageResizeK;
            byte[,,] Map = new byte[(int)(MapDx * MapPix_Meter), (int)(MapDy * MapPix_Meter), 3];
            int x, y, x3, y3;
            this.MapPicB.SizeMode = PictureBoxSizeMode.Zoom;
            byte[,,] Abyte;

            for (i = 0; i < ImageFileListN; i++)
            {
                using (Image A2 = Image.FromFile(ImageFileList[i]))
                {
                    Image A3;
                    //A = Image.FromFile(ImageFileList[i]);
                    ImageResizeK = MapPix_Meter / ImageScaleK[i];
                    A3 = ResizeImage(A2, Convert.ToInt32(A2.Width * ImageResizeK), Convert.ToInt32(A2.Height * ImageResizeK));
                    A3 = RotateImage((Bitmap)A3, (float)(ImageDir[i] / Math.PI * 180));
                    //MapPicB.Image = A;
                    //A.Save("C:/Users/03138529/Desktop/f1.png");

                    Abyte = new byte[A3.Width, A3.Height, 3];

                    Bitmap A1 = (Bitmap)A3.Clone();
                    for (int xi = 0; xi < A3.Width; xi++)
                    {
                        for (int yi = 0; yi < A3.Height; yi++)
                        {
                            pixelColor = A1.GetPixel(xi, yi);
                            Abyte[xi, yi, 0] = pixelColor.R;
                            Abyte[xi, yi, 1] = pixelColor.G;
                            Abyte[xi, yi, 2] = pixelColor.B;
                        }
                    }

                    x = (int)(ImageX[i] * MapPix_Meter - MinX);
                    y = MaxY - (int)(ImageY[i] * MapPix_Meter);

                    for (int xi = 0; xi < A3.Width; xi++)
                    {
                        for (int yi = 0; yi < A3.Height; yi++)
                        {
                            if (Abyte[xi, yi, 0] != 0)
                            {
                                x3 = x + xi;
                                y3 = y + yi;
                                Map[x3, y3, 0] = Abyte[xi, yi, 0];
                                Map[x3, y3, 1] = Abyte[xi, yi, 1];
                                Map[x3, y3, 2] = Abyte[xi, yi, 2];
                            }
                        }
                    }
                    //A3.Dispose();
                    //A1.Dispose();
                    SetStatusLabelText("Image transfomation " + Convert.ToString(i) + " / " + Convert.ToString(ImageFileListN));
                }
                GC.Collect();
            }

            Bitmap MapImage = new Bitmap((int)(MapDx * MapPix_Meter), (int)(MapDy * MapPix_Meter));
            for (int xi = 0; xi < MapImage.Width; xi++)
            {
                for (int yi = 0; yi < MapImage.Height; yi++)
                {
                    MapImage.SetPixel(xi, yi, Color.FromArgb(Map[xi, yi, 0], Map[xi, yi, 1], Map[xi, yi, 2]));
                }
                SetStatusLabelText("Map assembling " + Convert.ToString((int)((double)xi / MapImage.Width * 100)) + " %");
            }

            string s = Path.GetDirectoryName(ImageFileList[0]) + "/Map";
            Directory.CreateDirectory(s);
            MapImage.Save(s + "/" + "Map_" + Convert.ToString(MapPix_Meter) + ".png");
            MapPicB.Image = MapImage;
            SetStatusLabelText("");
            //DrawMap();
            GC.Collect();
        }

        public static Bitmap RotateImage(Bitmap bmpSrc, float theta)
        {
            Matrix mRotate = new Matrix();
            mRotate.Translate(bmpSrc.Width / -2, bmpSrc.Height / -2, MatrixOrder.Append);
            mRotate.RotateAt(theta, new System.Drawing.Point(0, 0), MatrixOrder.Append);
            using (GraphicsPath gp = new GraphicsPath())
            {  // transform image points by rotation matrix
                gp.AddPolygon(new System.Drawing.Point[] { new System.Drawing.Point(0, 0), new System.Drawing.Point(bmpSrc.Width, 0), new System.Drawing.Point(0, bmpSrc.Height) });
                gp.Transform(mRotate);
                System.Drawing.PointF[] pts = gp.PathPoints;

                // create destination bitmap sized to contain rotated source image
                Rectangle bbox = boundingBox(bmpSrc, mRotate);
                Bitmap bmpDest = new Bitmap(bbox.Width, bbox.Height);

                using (Graphics gDest = Graphics.FromImage(bmpDest))
                {  // draw source into dest
                    Matrix mDest = new Matrix();
                    mDest.Translate(bmpDest.Width / 2, bmpDest.Height / 2, MatrixOrder.Append);
                    gDest.Transform = mDest;
                    gDest.DrawImage(bmpSrc, pts);
                    return bmpDest;
                }
            }
        }

        private static Rectangle boundingBox(Image img, Matrix matrix)
        {
            GraphicsUnit gu = new GraphicsUnit();
            Rectangle rImg = Rectangle.Round(img.GetBounds(ref gu));

            // Transform the four points of the image, to get the resized bounding box.
            System.Drawing.Point topLeft = new System.Drawing.Point(rImg.Left, rImg.Top);
            System.Drawing.Point topRight = new System.Drawing.Point(rImg.Right, rImg.Top);
            System.Drawing.Point bottomRight = new System.Drawing.Point(rImg.Right, rImg.Bottom);
            System.Drawing.Point bottomLeft = new System.Drawing.Point(rImg.Left, rImg.Bottom);
            System.Drawing.Point[] points = new System.Drawing.Point[] { topLeft, topRight, bottomRight, bottomLeft };
            GraphicsPath gp = new GraphicsPath(points,
                                                                new byte[] { (byte)PathPointType.Start, (byte)PathPointType.Line, (byte)PathPointType.Line, (byte)PathPointType.Line });
            gp.Transform(matrix);
            return Rectangle.Round(gp.GetBounds());
        }
       
        public static Bitmap ResizeImage(Image image, int width, int height)
        {
            var destRect = new Rectangle(0, 0, width, height);
            var destImage = new Bitmap(width, height);

            destImage.SetResolution(image.HorizontalResolution, image.VerticalResolution);

            using (var graphics = Graphics.FromImage(destImage))
            {
                graphics.CompositingMode = CompositingMode.SourceCopy;
                graphics.CompositingQuality = CompositingQuality.HighQuality;
                graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
                graphics.SmoothingMode = SmoothingMode.HighQuality;
                graphics.PixelOffsetMode = PixelOffsetMode.HighQuality;

                using (var wrapMode = new ImageAttributes())
                {
                    wrapMode.SetWrapMode(WrapMode.TileFlipXY);
                    graphics.DrawImage(image, destRect, 0, 0, image.Width, image.Height, GraphicsUnit.Pixel, wrapMode);
                }
            }

            return destImage;
        }

        public static void FindLinesInScanningTrajectory(double[] X, double[] Y, out int RowN, out int[,] RowList)
        {
            RowN = 0;
            RowList = new int[100, 2];
            int N = X.Length;
            int aRow = 0, bRow = aRow + 1;
            int a, i, b, j;
            double[] w = new double[N];
            double[] x, y;
            double rSquared, yIntercept, slope, RMSE;

            while (bRow < N - 1)
            {
                for (i = 0; i < N; i++) w[i] = 1;

                a = bRow + 1;
                for (b = a + 3; b < N; b++)
                {
                    x = new double[b - a + 1];
                    y = new double[b - a + 1];
                    for (j = a; j <= b; j++)
                    {
                        x[j - a] = X[j];
                        y[j - a] = Y[j];
                    }
                    LinearRegression(x, y, out rSquared, out yIntercept, out slope, out RMSE);
                    w[b] = RMSE / (b - a);
                }
                bRow = Array.IndexOf(w, w.Min());

                for (i = 0; i < N; i++) w[i] = 1;

                for (a = aRow; a < bRow - 3; a++)
                {
                    x = new double[bRow - a + 1];
                    y = new double[bRow - a + 1];
                    for (j = a; j <= bRow; j++)
                    {
                        x[j - a] = X[j];
                        y[j - a] = Y[j];
                    }
                    LinearRegression(x, y, out rSquared, out yIntercept, out slope, out RMSE);
                    w[a] = RMSE / (bRow - a);
                }
                aRow = Array.IndexOf(w, w.Min());

                x = new double[bRow - aRow + 1];
                y = new double[bRow - aRow + 1];
                for (j = aRow; j <= bRow; j++)
                {
                    x[j - aRow] = X[j];
                    y[j - aRow] = Y[j];
                }
                LinearRegression(x, y, out rSquared, out yIntercept, out slope, out RMSE);

                while (aRow < bRow && Math.Abs(slope * X[aRow] + yIntercept - Y[aRow]) > RMSE * 1.5)
                    aRow++;

                while (aRow < bRow && Math.Abs(slope * X[bRow] + yIntercept - Y[bRow]) > RMSE * 1.5)
                    bRow--;

                RowList[RowN, 0] = aRow;
                RowList[RowN, 1] = bRow;
                RowN++;
            }
        }

        void DrawMap()
        {
            if (ImageFileListN == 0)
                return;
            MapPicBH = MapPicB.Height;
            double MapPicBW = MapPicB.Width;
            double dx = ImageX.Max() - ImageX.Min();
            double dy = ImageY.Max() - ImageY.Min();
            MapPicBK = MapPicBW / dx;
            if (MapPicBK > MapPicBH / dy)
                MapPicBK = MapPicBH / dy;

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

        private void Form1_SizeChanged(object sender, EventArgs e)
        {
            DrawMap();
        }

        public static void LinearRegression(double[] xVals, double[] yVals, out double rSquared, out double yIntercept, out double slope, out double RMSE)
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
            RMSE = 0;
            double e;
            for (int i = 0; i < xVals.Length; i++)
            {
                e = xVals[i] * slope + yIntercept - yVals[i];
                RMSE += e * e;
            }
            RMSE = Math.Sqrt(RMSE / xVals.Length);
        }








    }
}
