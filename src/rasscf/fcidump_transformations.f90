!***********************************************************************
! This file is part of OpenMolcas.                                     *
!                                                                      *
! OpenMolcas is free software; you can redistribute it and/or modify   *
! it under the terms of the GNU Lesser General Public License, v. 2.1. *
! OpenMolcas is distributed in the hope that it will be useful, but it *
! is provided "as is" and without any express or implied warranties.   *
! For more details see the full text of the license in the file        *
! LICENSE or in <http://www.gnu.org/licenses/>.                        *
!                                                                      *
! Copyright (C) 2014, Giovanni Li Manni                                *
!               2019, Oskar Weser                                      *
!***********************************************************************
module fcidump_transformations
  use stdalloc, only : mma_allocate, mma_deallocate
  implicit none
  private
  public :: get_orbital_E, fold_Fock
contains

!>  @brief
!>    Get the orbital energies.
!>
!>  @author Oskar Weser
!>
!>  @details
!>  If it is the first iteration (iter == 1), the one electron
!>  energies are read from the InpOrb.
!>  Otherwise orbital_energies is a copy of DIAF.
!>
!>  @param[in] iter
!>  @param[in] DIAF
!>  @param[out] orbital_energies
  subroutine get_orbital_E(iter, DIAF, orbital_energies)
    use general_data, only : nBas, nSym
    implicit none
    integer, intent(in) :: iter
    real(kind=8), intent(in) :: DIAF(:)
    real(kind=8), intent(inout) :: orbital_energies(:)

    if (iter == 1) then
      call read_orbital_energies(nSym, nBas, orbital_energies)
    else
      orbital_energies(:) = DIAF(:)
    end if
  contains
    subroutine read_orbital_energies(nSym, nBas, orbital_energies)
      implicit none
      integer, intent(in) :: nSym, nBas(:)
      real(kind=8), intent(inout) :: orbital_energies(:)
      real(kind=8) :: Dummy(1)
      integer :: LuInpOrb = 10, iDummy(1), err
      character(*), parameter ::  FnInpOrb = 'INPORB'
      character(80) :: VecTit
      logical :: okay
      call f_Inquire(FnInpOrb, okay)
      if (okay) then
        call RdVec(FnInpOrb,LuInpOrb,'E',nSym,nBas,nBas, &
          Dummy, Dummy, orbital_energies, iDummy, &
          VecTit, 0, err)
      else
        Write (6,*) 'RdCMO: Error finding MO file'
        call QTrace()
        call Abend()
      end if
    end subroutine read_orbital_energies
  end subroutine get_orbital_E


!>  @brief
!>    Fill in fock matrix elements.
!>
!>  @author Oskar Weser
!>
!>  @details
!>  The fock_table gets filled with the Fock matrix elements
!>  whose absolute value is larger than cutoff.
!>  The values are given by
!>  \f[ < i | F | j > \f]
!>  The index is given by i and j.
!>
!>  @param[in,out] fock_table
!>  @param[in] CMO The occupation number vector in MO-space.
!>  @param[in] F_In
!>    \f[\sum_{\sigma\rho} {In}^D_{\sigma\rho} (g_{\mu\nu\sigma\rho})  \f]
!>  @param[in] D1I_MO The inactive one-body density matrix in MO-space
!>  @param[in] cutoff Optional parameter that is set by default to
!>    fciqmc_tables::cutoff_default.
  subroutine fold_Fock(CMO, F_In, D1I_MO, folded_Fock)
    use general_data, only : nActEl, nAsh, ntot, ntot1, ntot2
    use rasscf_data, only : nAcPar, core_energy => Emy
    use index_symmetry, only : one_el_idx_flatten
    implicit none
    real(8), intent(in) :: CMO(nTot2), F_In(nTot1), D1I_MO(nTot2)
    real(8), intent(inout) :: folded_Fock(:)
    integer :: i, n
    real(8) :: core_E_per_act_el
    real(8), allocatable :: &
! active one-body density matrix in AO-space
        D1A_AO(:),&
! active one-body density matrix in MO-space
        D1A_MO(:),&
        F_In_copy(:)

    call mma_allocate(D1A_AO, nTot2)
    call mma_allocate(D1A_MO, nTot2)
    call mma_allocate(F_In_copy, size(F_In))
    F_In_copy(:) = F_In(:)
    call get_D1A_RASSCF(CMO, D1A_MO, D1A_AO)
! SGFCIN has side effects and EMY/core_energy is set in this routine.
! Besides F_In will contain the one electron contribution afterwards,
! for this reason it is copied.

! SGFCIN has to be called once with F_In
    call SGFCIN(CMO, folded_fock, F_In, D1I_MO, D1A_MO, D1A_AO)
    call mma_deallocate(F_In_copy)
    call mma_deallocate(D1A_MO)
    call mma_deallocate(D1A_AO)

! Remove the one electron contribution in the diagonal elements.
    if (nActEl /= 0) then
      core_E_per_act_el = core_energy / dble(nActEl)
    else
      core_E_per_act_el = 0.0d0
    end if

    do i = 1, sum(nAsh)
      n = one_el_idx_flatten(i, i)
      folded_Fock(n) = folded_Fock(n) - core_E_per_act_el
    end do
  end subroutine fold_Fock

end module fcidump_transformations
