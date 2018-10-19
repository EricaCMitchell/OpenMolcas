************************************************************************
* This file is part of OpenMolcas.                                     *
*                                                                      *
* OpenMolcas is free software; you can redistribute it and/or modify   *
* it under the terms of the GNU Lesser General Public License, v. 2.1. *
* OpenMolcas is distributed in the hope that it will be useful, but it *
* is provided "as is" and without any express or implied warranties.   *
* For more details see the full text of the license in the file        *
* LICENSE or in <http://www.gnu.org/licenses/>.                        *
************************************************************************
      Subroutine Dys_Interf(SO,i_root,NZ,CMO,ENE,OCC)
************************************************************************
!     +++ J. Creutzberg, J. Norell - 2018
!     Subroutine to generate .DysOrb and .molden files for Dyson orbitals
!     heavily based on the interf subroutine.

!     The UHF logical parameter to molden_interface could be used to
!     produce separate alpha and beta orbitals.
************************************************************************
      Implicit Real*8 (a-h,o-z)
#include "rasdim.fh"
#include "general.fh"
#include "casvb.fh"
#include "WrkSpc.fh"
#include "output_ras.fh"
      Parameter (ROUTINE='INTERF  ')
      Character*30 Filename
      Character*30 orbfile
      Character*80 Note
      Logical SO

      Dimension ENE(*)
      Dimension CMO(*)
      Dimension OCC(*)
*                                                                      *

************************************************************************
*                                                                      *
*     Make the .DysOrb file (for use with Molden_interface)
*
      IF (SO) THEN
       Write(orbfile,'(A10,I1)') 'DYSORB.SO.',i_root
      ELSE
       Write(orbfile,'(A10,I1)') 'DYSORB.SF.',i_root
      ENDIF
      Note='Temporary orbital file for the MOLDEN interface.'
      LuTmp=50
      LuTmp=IsFreeUnit(LuTmp)
      Call WrVec(orbfile,LuTmp,'COE',1,NZ,NZ,
     &     CMO,OCC,ENE,5,Note)

* Parameter number 4 should in principle give the symmetry of the
* orbital. For now we will put them all in the same symmetry 1.
* This could be improved later.

*                                                                      *
************************************************************************
*                                                                      *
*     Call the generic MOLDEN interface

      IF (SO) THEN
       Write(filename,'(A17,I1)') 'DysOrb.SO.molden.',i_root
      ELSE
       Write(filename,'(A17,I1)') 'DysOrb.SF.molden.',i_root
      ENDIF
      Call Molden_Interface(0,orbfile,filename,.False.)
*
* The first parameter is a logical for UHF which could be used to
* separate alpha and beta orbital in the future.
* Functionality enabled by the last paramter is not understood, but
* probably not useful for us.
************************************************************************
*                                                                      *
      Return
      End
