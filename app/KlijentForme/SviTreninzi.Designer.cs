namespace KlijentForme
{
    partial class SviTreninzi
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            label1 = new Label();
            buttonSviTreninzi = new Button();
            label2 = new Label();
            dataGridViewTreninzi = new DataGridView();
            buttonTrening = new Button();
            ((System.ComponentModel.ISupportInitialize)dataGridViewTreninzi).BeginInit();
            SuspendLayout();
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(12, 52);
            label1.Name = "label1";
            label1.Size = new Size(143, 20);
            label1.TabIndex = 0;
            label1.Text = "Prikaz svih treninga: ";
            // 
            // buttonSviTreninzi
            // 
            buttonSviTreninzi.Location = new Point(176, 44);
            buttonSviTreninzi.Name = "buttonSviTreninzi";
            buttonSviTreninzi.Size = new Size(107, 36);
            buttonSviTreninzi.TabIndex = 1;
            buttonSviTreninzi.Text = "Prikaži";
            buttonSviTreninzi.UseVisualStyleBackColor = true;
            buttonSviTreninzi.Click += buttonSviTreninzi_Click;
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(103, 111);
            label2.Name = "label2";
            label2.Size = new Size(0, 20);
            label2.TabIndex = 2;
            // 
            // dataGridViewTreninzi
            // 
            dataGridViewTreninzi.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewTreninzi.Location = new Point(12, 111);
            dataGridViewTreninzi.Name = "dataGridViewTreninzi";
            dataGridViewTreninzi.RowHeadersWidth = 51;
            dataGridViewTreninzi.Size = new Size(693, 188);
            dataGridViewTreninzi.TabIndex = 4;
            // 
            // buttonTrening
            // 
            buttonTrening.Location = new Point(723, 178);
            buttonTrening.Name = "buttonTrening";
            buttonTrening.Size = new Size(168, 52);
            buttonTrening.TabIndex = 7;
            buttonTrening.Text = "Prikaži detalje o treningu";
            buttonTrening.UseVisualStyleBackColor = true;
            buttonTrening.Click += buttonTrening_Click;
            // 
            // SviTreninzi
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(920, 336);
            Controls.Add(buttonTrening);
            Controls.Add(dataGridViewTreninzi);
            Controls.Add(label2);
            Controls.Add(buttonSviTreninzi);
            Controls.Add(label1);
            Name = "SviTreninzi";
            Text = "Pretraga treninga";
            ((System.ComponentModel.ISupportInitialize)dataGridViewTreninzi).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Label label1;
        private Button buttonSviTreninzi;
        private Label label2;
        private ComboBox comboBoxTrener;
        private DataGridView dataGridViewTreninzi;
        private Button buttonTrening;
        private Label label3;
    }
}