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
      Program main
c
      Implicit Real*8(a-h,o-z)
      Character*20 Module_Name
      Parameter (Module_Name = 'localisation')
c
      Call Start(Module_Name)
      Call Localisation(ireturn)
      Call Finish(ireturn)
c
      End
