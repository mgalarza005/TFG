-- USE SPL;

CREATE TABLE SPL (
	ID VARCHAR(50) NOT NULL,
	NAME VARCHAR(100) NOT NULL,
	CONSTRAINT PK_SPL PRIMARY KEY (ID)
);

CREATE TABLE GIT_SPL (
	ID VARCHAR(50) NOT NULL,
	URL VARCHAR(100),
	LAST_CHANGED DATETIME NOT NULL,
	CONSTRAINT GIT_SPL_PK PRIMARY KEY (ID),
	CONSTRAINT GIT_SPL_FK_SPL FOREIGN KEY (ID) REFERENCES SPL(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE FEATURE_MODEL (
	ID VARCHAR(50) NOT NULL,
	FILENAME VARCHAR(100) NOT NULL,
	PATH VARCHAR(200) NOT NULL,
	SPL VARCHAR(50) NOT NULL,
	CONSTRAINT FEATURE_MODEL_PK PRIMARY KEY (ID),
	CONSTRAINT FEATURE_MODEL_FK_SPL FOREIGN KEY (SPL) REFERENCES SPL(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE FEATURE (
	ID VARCHAR(50) NOT NULL,
	NAME VARCHAR(50) NOT NULL,
	TYPE VARCHAR(20) NOT NULL,
	PARENT VARCHAR(50), -- NULL IN CASE IS ROOT
	FEATURE_MODEL VARCHAR(50) NOT NULL,
	CONSTRAINT FEATURE_PK PRIMARY KEY (ID),
	CONSTRAINT FEATURE_FK_PARENT FOREIGN KEY (PARENT) REFERENCES FEATURE(ID) ON DELETE CASCADE,
	CONSTRAINT FEATURE_FK_FEATURE_MODEL FOREIGN KEY (FEATURE_MODEL) REFERENCES FEATURE_MODEL(ID)
);

CREATE TABLE ATTRIBUTE (
	ID VARCHAR(50) NOT NULL,
	NAME VARCHAR(50) NOT NULL,
	TYPE VARCHAR(20) NOT NULL,
	VALUE VARCHAR(100) NOT NULL,
	TARGET_FEATURE VARCHAR(50) NOT NULL,
	CONSTRAINT ATTRIBUTE_PK PRIMARY KEY (ID),
	CONSTRAINT ATTRIBUTE_FK_TARGET_FEATURE FOREIGN KEY (TARGET_FEATURE) REFERENCES FEATURE(ID)
);

CREATE TABLE DEPENDENCY (
	ID VARCHAR(50) NOT NULL,
	TYPE VARCHAR(20) NOT NULL,
	SOURCE_FEATURE VARCHAR(50) NOT NULL,
	TARGET_FEATURE VARCHAR(50) NOT NULL,
	CONSTRAINT DEPENDENCIES_PK PRIMARY KEY (ID),
	CONSTRAINT DEPENDENCIES_FK_SOURCE FOREIGN KEY (SOURCE_FEATURE) REFERENCES FEATURE(ID),
	CONSTRAINT DEPENDENCIES_FK_TARGET FOREIGN KEY (TARGET_FEATURE) REFERENCES FEATURE(ID)
);

CREATE TABLE FEATURE_SIZE(
	FEATURE_ID VARCHAR(50) NOT NULL,
	SIZE INTEGER NOT NULL,
	CONSTRAINT FEATURE_CODE_SIZE_PK PRIMARY KEY (FEATURE_ID),
	CONSTRAINT FEATURE_CODE_SIZE_FK_FEATURE_ID FOREIGN KEY (FEATURE_ID) REFERENCES FEATURE(ID)
);

CREATE TABLE CODE_ELEMENT (
	ID VARCHAR(50) NOT NULL,
	PATH VARCHAR(200) NOT NULL,
	TYPE VARCHAR(20) NOT NULL,
	PARENT VARCHAR(50), -- NULL IN CASE IS ROOT
	SPL_ID VARCHAR(50) NOT NULL,
	CONSTRAINT CODE_ELEMENT_PK PRIMARY KEY (ID),
	CONSTRAINT CODE_ELEMENT_FK_PARENT FOREIGN KEY (PARENT) REFERENCES CODE_ELEMENT(ID) ON DELETE CASCADE,
	CONSTRAINT CODE_ELEMENT_FK_SPL_ID FOREIGN KEY (SPL_ID) REFERENCES SPL(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DIRECTORY (
	ID VARCHAR(50) NOT NULL,
	CONSTRAINT DIRECTORY_PK PRIMARY KEY (ID),
	CONSTRAINT DIRECTORY_FK_ID FOREIGN KEY (ID) REFERENCES CODE_ELEMENT(ID)
);

CREATE TABLE PART (
	ID VARCHAR(50) NOT NULL,
	PART_TYPE VARCHAR(50) NOT NULL,
	CONSTRAINT PART_PK PRIMARY KEY (ID),
	CONSTRAINT PART_FK_ID FOREIGN KEY (ID) REFERENCES CODE_ELEMENT(ID)
);

CREATE TABLE CODEFILE (
	ID VARCHAR(50) NOT NULL,
	FILENAME VARCHAR(100) NOT NULL,
	CONSTRAINT CODEFILE_PK PRIMARY KEY (ID),
	CONSTRAINT CODEFILE_FK_ID FOREIGN KEY (ID) REFERENCES CODE_ELEMENT(ID)
);

CREATE TABLE VARIATION_POINT (
	ID VARCHAR(50) NOT NULL,
	CODE_ELEMENT_ID VARCHAR(50) NOT NULL,
	EXPRESION VARCHAR(200) NOT NULL,
	VP_SIZE INTEGER NOT NULL,
	CONSTRAINT VARIATION_POINT_PK PRIMARY KEY (ID),
	CONSTRAINT VARIATION_POINT_FK_CODE_ELEMENT_ID FOREIGN KEY (CODE_ELEMENT_ID) REFERENCES CODE_ELEMENT(ID)
);

CREATE TABLE CODE_VARIATION_POINT (
	VP_ID VARCHAR(50) NOT NULL,
	START_LINE INTEGER NOT NULL,
	END_LINE INTEGER NOT NULL,
	CONTENT TEXT NOT NULL,
	NESTING_LEVEL INTEGER NOT NULL,
	CONSTRAINT CODE_VARIATION_POINT_PK PRIMARY KEY (VP_ID),
	CONSTRAINT CODE_VARIATION_POINT_FK_VP_ID FOREIGN KEY (VP_ID) REFERENCES VARIATION_POINT(ID)
);

CREATE TABLE VARIATION_POINT_FEATURE (
	VP_ID VARCHAR(50) NOT NULL,
	FEATURE_ID VARCHAR(50) NOT NULL,
	CONSTRAINT VARIATION_POINT_FEATURE_PK PRIMARY KEY (VP_ID,FEATURE_ID),
	CONSTRAINT VARIATION_POINT_FEATURE_FK_VP_ID FOREIGN KEY (VP_ID) REFERENCES VARIATION_POINT(ID),
	CONSTRAINT VARIATION_POINT_FEATURE_FK_FEATURE_ID FOREIGN KEY (FEATURE_ID) REFERENCES FEATURE(ID)
);

CREATE TABLE VARIANT_MODEL (
	ID VARCHAR(50) NOT NULL,
	FILENAME VARCHAR(100) NOT NULL,
	PATH VARCHAR(200) NOT NULL,
	SPL_ID VARCHAR(50) NOT NULL,
	CONSTRAINT VARIANT_MODEL_PK PRIMARY KEY (ID),
	CONSTRAINT VARIANT_MODEL_FK_SPL_ID FOREIGN KEY (SPL_ID) REFERENCES SPL(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE VARIANT_COMPONENT (
	ID VARCHAR(50) NOT NULL,
	VARIANT_MODEL VARCHAR(50) NOT NULL,
	IS_SELECTED BOOLEAN,
	CONSTRAINT VARIANT_COMPONENT_PK PRIMARY KEY (ID),
	CONSTRAINT VARIANT_COMPONENT_FK_VARIANT_MODEL FOREIGN KEY (VARIANT_MODEL) REFERENCES VARIANT_MODEL(ID)
);

CREATE TABLE VARIANT_CODE (
	VC_ID VARCHAR(50) NOT NULL,
	CODE_ELEMENT_ID VARCHAR(50) NOT NULL,
	CONSTRAINT VARIANT_COMPONENT_FK_CODE_ELEMENT_ID FOREIGN KEY (CODE_ELEMENT_ID) REFERENCES CODE_ELEMENT(ID)
);

CREATE TABLE VARIANT_FEATURE(
	VC_ID VARCHAR(50) NOT NULL,
	FEATURE_ID VARCHAR(50) NOT NULL,
	CONSTRAINT VARIANT_COMPONENT_FK_FEATURE_ID FOREIGN KEY (FEATURE_ID) REFERENCES FEATURE(ID)
);