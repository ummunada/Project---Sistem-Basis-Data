CREATE TYPE jeniskelamin_type as Enum('Perempuan','Laki-laki')
CREATE TYPE agama_type as Enum('Islam','Kristen','Katolik','Lainnya')
CREATE TYPE statusperkawinan_type as Enum('Belum Menikah','Sudah Menikah')
CREATE TABLE Penduduk (
    id_penduduk       INTEGER NOT NULL,
    nama_lengkap      VARCHAR(64) NOT NULL,
    NIK               VARCHAR(32) NOT NULL,
    jenis_kelamin     jeniskelamin_type NOT NULL,
    tempat_lahir      VARCHAR(32) NOT NULL,
    tanggal_lahir     DATE NOT NULL,
    agama             agama_type NOT NULL,
    pekerjaan         TEXT NOT NULL,
    status_perkawinan statusperkawinan_type NOT NULL,
    alamat            TEXT NOT NULL,
    no_telepon        VARCHAR(16) NOT NULL
);

ALTER TABLE Penduduk ADD CONSTRAINT Penduduk_pk PRIMARY KEY ( id_penduduk );
ALTER TABLE Penduduk ADD CONSTRAINT Penduduk_NIK_un UNIQUE ( NIK );

CREATE TABLE Petugas (
    id_petugas     INTEGER NOT NULL,
    nama_lengkap   VARCHAR(64) NOT NULL,
    NIPD           VARCHAR(32) NOT NULL,
    jenis_kelamin  jeniskelamin_type NOT NULL,
    tempat_lahir   VARCHAR(32) NOT NULL,
    tanggal_lahir  DATE NOT NULL,
    alamat         TEXT NOT NULL,
    no_telepon     VARCHAR(16) NOT NULL
);

ALTER TABLE Petugas ADD CONSTRAINT Petugas_pk PRIMARY KEY ( id_petugas );
ALTER TABLE Petugas ADD CONSTRAINT Petugas_NIPD_un UNIQUE ( NIPD );

CREATE TABLE Kepala_Desa (
    id_kepala_desa INTEGER NOT NULL,
    nama_lengkap   VARCHAR(64) NOT NULL,
    NIPD           VARCHAR(32) NOT NULL,
    jenis_kelamin  jeniskelamin_type NOT NULL,
    tempat_lahir   VARCHAR(32) NOT NULL,
    tanggal_lahir  DATE NOT NULL,
    alamat         TEXT NOT NULL,
    jabatan        TEXT NOT NULL,
    tanggal_masuk  DATE NOT NULL,
    tanggal_keluar DATE NOT NULL,
    no_telepon     VARCHAR(16) NOT NULL
);

ALTER TABLE Kepala_Desa ADD CONSTRAINT Kepala_Desa_pk PRIMARY KEY ( id_kepala_desa );
ALTER TABLE Kepala_Desa ADD CONSTRAINT Kepala_Desa_NIPD_un UNIQUE ( NIPD );

CREATE TABLE Jenis_Surat (
    id_jenis   INTEGER NOT NULL,
    nama_surat VARCHAR(84) NOT NULL
);

ALTER TABLE Jenis_Surat ADD CONSTRAINT Jenis_Surat_pk PRIMARY KEY ( id_jenis );

CREATE TYPE status_type as Enum('Belum di ACC', 'Sudah di ACC','Menunggu Antrian','Sedang Diproses','Surat Telah Selesai')
CREATE TABLE Permohonan_Surat (
    id_permohonan              INTEGER NOT NULL,
    tanggal_permohonan         DATE NOT NULL,
    no_surat                   INTEGER NOT NULL,
    keperluan                  TEXT NOT NULL,
    status                     status_type NOT NULL,
    keterangan                 TEXT NULL,
    kepala_desa_id_kepala_desa INTEGER NOT NULL,
    petugas_id_petugas         INTEGER NOT NULL,
    penduduk_id_penduduk       INTEGER NOT NULL,
    jenis_surat_id_jenis       INTEGER NOT NULL
);

ALTER TABLE Permohonan_Surat ADD CONSTRAINT Permohonan_Surat_pk PRIMARY KEY ( id_permohonan );
ALTER TABLE Permohonan_Surat ADD CONSTRAINT Permohonan_Surat_no_surat_un UNIQUE ( no_surat );
ALTER TABLE Permohonan_Surat ADD CONSTRAINT Permohonan_Surat_kepala_desa_fk FOREIGN KEY ( kepala_desa_id_kepala_desa )
REFERENCES Kepala_Desa ( id_kepala_desa );
ALTER TABLE Permohonan_Surat ADD CONSTRAINT Permohonan_Surat_petugas_fk FOREIGN KEY ( petugas_id_petugas )
REFERENCES Petugas ( id_petugas );
ALTER TABLE Permohonan_Surat ADD CONSTRAINT Permohonan_Surat_penduduk_fk FOREIGN KEY ( penduduk_id_penduduk )
REFERENCES Penduduk ( id_penduduk );
ALTER TABLE Permohonan_Surat ADD CONSTRAINT Permohonan_Surat_jenis_surat_fk FOREIGN KEY ( jenis_surat_id_jenis )
REFERENCES Jenis_Surat ( id_jenis );
ALTER TABLE Permohonan_Surat
ALTER COLUMN keterangan set default 'Tidak ada keterangan';

CREATE TABLE Persyaratan (
    id_persyaratan INTEGER NOT NULL,
    fc_kk          Bytea Not NULL,
    fc_ktp         Bytea Not NULL
);

ALTER TABLE Persyaratan ADD CONSTRAINT Persyaratan_pk PRIMARY KEY ( id_persyaratan );

CREATE TABLE SKBM (
    fc_ktp_saksi   Bytea Not NULL,
    id_persyaratan INTEGER NOT NULL
);

ALTER TABLE SKBM ADD CONSTRAINT SKBM_persyaratan_fk FOREIGN KEY ( id_persyaratan )
REFERENCES Persyaratan ( id_persyaratan );

CREATE TABLE SKTM (
    kartu_identitas_miskin Bytea Null,
    id_persyaratan         INTEGER NOT NULL
);

ALTER TABLE SKTM ADD CONSTRAINT SKTM_persyaratan_fk FOREIGN KEY ( id_persyaratan )
REFERENCES Persyaratan ( id_persyaratan );

CREATE TABLE SPPA (
    surat_kelahiran Bytea NOT NULL,
    fc_buku_nikah   Bytea NOT NULL,
    id_persyaratan  INTEGER NOT NULL
);

ALTER TABLE SPPA ADD CONSTRAINT SPPA_persyaratan_fk FOREIGN KEY ( id_persyaratan )
REFERENCES Persyaratan ( id_persyaratan );

CREATE TABLE SPPK (
    fc_surat_nikah Bytea NOT NULL,
    fc_akta        Bytea NOT NULL,
    id_persyaratan INTEGER NOT NULL
);

ALTER TABLE SPPK ADD CONSTRAINT SPPK_persyaratan_fk FOREIGN KEY ( id_persyaratan )
REFERENCES Persyaratan ( id_persyaratan );

CREATE TABLE Detail_Persyaratan (
    id_detail_persyaratan      INTEGER NOT NULL,
    keterangan                 TEXT NULL,
    persyaratan_id_persyaratan INTEGER NOT NULL,
    jenis_surat_id_jenis       INTEGER NOT NULL
);

ALTER TABLE Detail_Persyaratan ADD CONSTRAINT Detail_Persyaratan_pk PRIMARY KEY ( id_detail_persyaratan );
ALTER TABLE Detail_Persyaratan ADD CONSTRAINT Detail_Persyaratan_jenis_surat_fk FOREIGN KEY ( jenis_surat_id_jenis )
REFERENCES Jenis_Surat ( id_jenis ); 
ALTER TABLE Detail_Persyaratan ADD CONSTRAINT Detail_persyaratan_persyaratan_fk FOREIGN KEY ( persyaratan_id_persyaratan )
REFERENCES Persyaratan ( id_persyaratan );
ALTER TABLE Detail_Persyaratan
ALTER COLUMN keterangan set default 'Tidak ada keterangan';

Insert Into Penduduk(id_penduduk,nama_lengkap,NIK,jenis_kelamin,tempat_lahir,
					 tanggal_lahir,agama,pekerjaan,status_perkawinan,alamat,no_telepon)
Values(1001,'Ummu Nada','350525678900001','Perempuan','Jember','2004-05-23',
	   'Islam','Mahasiswa','Belum Menikah','Jalan Wijayakusuma No 27','085607101567'),
	  (1002,'Dedy Suherman','3505275200010','Laki-laki','Jember','1998-04-03',
	   'Islam','Karyawan Swasta','Sudah Menikah','Jalan Argopuro No 15','085749071290'),
	  (1003,'Adifa Kanzia','350525786000120','Perempuan','Jember','2005-03-04',
	   'Islam','Pelajar','Belum Menikah','Jalan Krakatau No 13','085223768412')
	   
Insert Into Petugas(id_petugas,nama_lengkap,NIPD,jenis_kelamin,tempat_lahir,
					tanggal_lahir,alamat,no_telepon)
Values(2001,'Vivi Audia','198608136279111111','Perempuan','Jember',
	  '1986-05-14','Jalan Krakatau No 15','081273457189'),
	  (2002,'Andre Rahmawan','198247891111222888','Laki-laki','Jember',
	  '1982-03-03','Jalan Argopuro No 12','085743256112'),
	  (2003,'Andini Aisyah','198521700001455339','Perempuan','Jember',
	  '1985-02-17','Jalan Wijayakusuma No 25','085602415224')

Insert Into Kepala_Desa(id_kepala_desa,nama_lengkap,NIPD,jenis_kelamin,tempat_lahir,
						tanggal_lahir,alamat,jabatan,tanggal_masuk,tanggal_keluar,no_telepon)
Values(3001,'Keisya Akhmala','198233300011152268','Perempuan','Jember','1982-01-15',
	 'Jalan Argopuro 13','Kepala Desa','2015-01-22','2019-01-22','085426351754'),
	 (3002,'Imam Waluyo','197489999444455553','Laki-laki','Jember','1974-06-04',
	 'Jalan Wijayakusuma No 19','Kepala Desa','2019-05-23','2023-05-23','085478920876'),
	 (3003,'Aryo Rahman','197622223333444476','Laki-laki','Jember','1976-02-01',
	 'Jalan Krakatau No 15','Kepala Desa','2023-10-15','2023-10-15','085627885443')

Insert Into Jenis_Surat(id_jenis,nama_surat)
Values(01,'Surat Keterangan Tidak Mampu'),
      (02,'Surat Pengantar Pembuatan Kartu Keluarga'),
	  (03,'Surat Pengantar Pembuatan Akta Kelahiran')

Insert Into Permohonan_Surat(id_permohonan,tanggal_permohonan,no_surat,keperluan,
							status,keterangan,kepala_desa_id_kepala_desa,petugas_id_petugas,
							penduduk_id_penduduk,jenis_surat_id_jenis)
Values(1,'2023-04-16',001,'Untuk mendaftar beasiswa','Belum di ACC',
	  'Data sedang diperiksa oleh petugas',3001,2001,1001,01),
	  (2,'2023-04-16',002,'Untuk membuat kartu keluarga','Sedang Diproses',
	  'Surat ditandatangani kepala desa',3001,2002,1002,02),
	  (3,'2023-04-17',003,'Untuk membuat Akta Kelahiran','Surat Telah Selesai',
	  'Surat sudah bisa dicetak',3002,2003,1003,03)
	  
Insert Into Persyaratan(id_persyaratan,fc_kk,fc_ktp)
Values(1,' ',' '),
      (2,' ',' '),
	  (3,' ',' '),
	  (4,' ',' ')
	  
Insert Into SKTM(kartu_identitas_miskin,id_persyaratan)
Values(' ',1),
	  (' ',1),
	  (' ',1)
	 
Insert Into SPPK(fc_surat_nikah,fc_akta,id_persyaratan)
Values(' ',' ',2),
	  (' ',' ',2),
	  (' ',' ',2)
	  
Insert Into SPPA(surat_kelahiran,fc_buku_nikah,id_persyaratan)
Values(' ',' ',3),
	  (' ',' ',3),
	  (' ',' ',3)

Insert Into SKBM(fc_ktp_saksi,id_persyaratan)
Values(' ',4),
	  (' ',4),
	  (' ',4)
	  
Insert Into Detail_Persyaratan(id_detail_persyaratan,persyaratan_id_persyaratan,
							   jenis_surat_id_jenis)
Values(010,1,1),
	  (011,2,2),
	  (012,3,3)
	  
select * from Penduduk
select * from Petugas
select * from Kepala_Desa
select * from Jenis_Surat
select * from Permohonan_Surat
select * from Persyaratan
select * from SKTM
select * from SPPK
select * from SPPA
select * from SKBM
select * from Detail_Persyaratan