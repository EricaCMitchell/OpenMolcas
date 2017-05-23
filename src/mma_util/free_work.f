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
* Copyright (C) Roland Lindh                                           *
************************************************************************
      Subroutine Free_Work(ip)
************************************************************
*
*   <DOC>
*     <Name>Free\_Work</Name>
*     <Syntax>Call Free\_Work(ip)</Syntax>
*     <Arguments>
*       \Argument{ip}{pointer to memory in Work}i{integer}{inout}
*     </Arguments>
*     <Purpose>To deallocate memory in Work associated with pointer ip.</Purpose>
*     <Dependencies></Dependencies>
*     <Author>Roland Lindh</Author>
*     <Modified_by></Modified_by>
*     <Side_Effects></Side_Effects>
*     <Description>
*     The array associated to pointer/identifier ip Work is deallocted.
*     </Description>
*    </DOC>
*
************************************************************
      Implicit Real*8 (a-h,o-z)
#include "WrkSpc.fh"
*
      Call GetMem('AW','Free','Real',ip,0)
*
      Return
      End
