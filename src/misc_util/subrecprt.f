************************************************************************
* This file is part of OpenMolcas.                                     *
*                                                                      *
* OpenMolcas is free software; you can redistribute it and/or modify   *
* it under the terms of the GNU Lesser General Public License, v. 2.1. *
* OpenMolcas is distributed in the hope that it will be useful, but it *
* is provided "as is" and without any express or implied warranties.   *
* For more details see the full text of the license in the file        *
* LICENSE or in <http://www.gnu.org/licenses/>.                        *
*                                                                      *
* Copyright (C) 1992, Markus P. Fuelscher                              *
*               2014, Ignacio Fdez. Galvan (modified from RecPrt)      *
************************************************************************
      Subroutine SubRecPrt(Title,FmtIn,A,nRow,nCol,nRowSub)
************************************************************
*
*   <DOC>
*     <Name>SubRecPrt</Name>
*     <Syntax>Call SubRecPrt(Title,FmtIn,A,nRow,nCol,nRowSub)</Syntax>
*     <Arguments>
*       \Argument{Title}{Title card}{Character*(*)}{in}
*       \Argument{FmtIn}{Format statement}{Character*(*)}{in}
*       \Argument{A}{A matrix}{Real*8}{in}
*       \Argument{nRow}{number of rows of A}{Integer}{in}
*       \Argument{nCol}{number of columns of A}{Integer}{in}
*       \Argument{nRowSub}{number of rows of A to print}{Integer}{in}
*     </Arguments>
*     <Purpose>To write out part of a matrix on standard out.</Purpose>
*     <Dependencies></Dependencies>
*     <Author>M. P. Fuelscher</Author>
*     <Modified_by>I. Fdez. Galvan</Modified_by>
*     <Side_Effects></Side_Effects>
*     <Description>
*     The first nRowSub rows of a matrix A of dimension nRow x nCol are printed
*     in output preceded by the character line Title. Format of the numerical
*     output is given by FmtIn. If FmtIn='' the utility will decide on format
*     for optimal output.
*     </Description>
*    </DOC>
*
************************************************************
************************************************************************
*                                                                      *
*     purpose:                                                         *
*     Print a rectangular submatrix                                    *
*                                                                      *
*     calling arguments                                                *
*     Title  : character string containing a title                     *
*              If the string is empty no title will be printed         *
*     A      : rectangular matrix of double precision reals            *
*     nRow   : row dimension of matrix A                               *
*     nCol   : column dimension of matrix A                            *
*     nRowSub: number of rows of A to print                            *
*                                                                      *
*----------------------------------------------------------------------*
*                                                                      *
*     written by:                                                      *
*     M. P. Fuelscher                                                  *
*     University of Lund, Sweden, 1992                                 *
*                                                                      *
*----------------------------------------------------------------------*
*                                                                      *
*     history:                                                         *
*     Feb. 2014: Modified from RecPrt                                  *
*                                                                      *
************************************************************************
      Implicit Real*8 (A-H,O-Z)
#include "standard_iounits.fh"
      Character*(*) Title
      Character*(*) FmtIn
      Dimension A(nRow,nCol)
      Integer StrnLn
      Parameter (lPaper=120,lMaxTitle=60)
      Character*(lMaxTitle) Line
      Character*20 FMT
*----------------------------------------------------------------------*
      If (nRowSub*nCol.eq.0) Return
#ifdef _DEBUG_
      Call TrcPrt(Title,FmtIn,A,nRow,nCol)
      Return
#endif
*----------------------------------------------------------------------*
*     print the title                                                  *
*----------------------------------------------------------------------*
      lTitle=StrnLn(Title)
      If ( lTitle.gt.0 ) then
         Do 10 i=1,lMaxTitle
             Line(i:i)=' '
10       Continue
         lLeft=1
         Do 20 i=lTitle,1,-1
            If ( Title(i:i).ne.' ' ) lLeft=i
20       Continue
         lLeft=lLeft-1
         Do 25 i=1,lMaxTitle
            If ( i+lLeft.le.lTitle ) Line(i:i)=Title(i+lLeft:i+lLeft)
25       Continue
         Write(LuWr,*)
         Write(LuWr,'(2X,A)') Line
c         Do 30 i=1,StrnLn(Line)
c            Line(i:i)='-'
c30       Continue
c         Write(LuWr,'(2X,A)') Line
         Write(LuWr,'(2X,A,I5,A,I5)') 'mat. size = ',nRowSub,'x',nCol
      End If
*----------------------------------------------------------------------*
*     determine the printing format                                    *
*----------------------------------------------------------------------*
      lFmt=Strnln(FmtIn)
      If ( lFmt.ne.0 ) then
         FMT=FmtIn
      Else
         Amax=A(1,1)
         Amin=A(1,1)
         Do 40 j=1,nCol
            Do 50 i=1,nRowSub
               Amax=Max(Amax,A(i,j))
               Amin=Min(Amin,A(i,j))
50          Continue
40       Continue
         Pmax=0.0D0
         If ( Abs(Amax).gt.1.0D-72 ) Pmax=Log10(Abs(Amax))
         iPmax=1+INT(Pmax)
         iPmax=Max(1,iPmax)
         Pmin=0.0D0
         If ( Abs(Amin).gt.1.0D-72 ) Pmin=Log10(Abs(Amin))
         iPmin=1+INT(Pmin)
         iPmin=Max(1,iPmin)
         nDigit=14
         nDecim=Min(8,nDigit-Max(iPmin,iPmax))
         nDecim=Max(nDecim,1)
         If ( Amax.lt.0.0D0 ) iPmax=iPmax+1
         If ( Amin.lt.0.0D0 ) iPmin=iPmin+1
         lNumbr=Max(iPmin,iPmax)+nDecim+2
         nCols=10
         lLine=nCols*lNumbr
         If ( lLine.gt.lPaper ) then
            If ( lLine.le.lPaper+nCols .and. nDecim.gt.1 ) then
               nDecim=nDecim-1
               lNumbr=Max(iPmin,iPmax)+nDecim
               lItem=Max(lNumbr,lPaper/nCols)
            Else
               nCols=5
               lItem=Max(lNumbr,lPaper/nCols)
            End If
         Else
            lItem=lNumbr
         End If
         Write(FMT,'(A,   I4.4,  A, I4.4,  A, I4.4,   A)')
     &             '(2X,',nCols,'F',lItem,'.',nDecim,')'
      End if
*----------------------------------------------------------------------*
*     print the data                                                   *
*----------------------------------------------------------------------*
c      Write(LuWr,*)
      Do 60 i=1,nRowSub
         Write(LuWr,FMT)(A(i,j),j=1,nCol)
60    Continue
*----------------------------------------------------------------------*
*     End procedure                                                    *
*----------------------------------------------------------------------*
      Return
      End
