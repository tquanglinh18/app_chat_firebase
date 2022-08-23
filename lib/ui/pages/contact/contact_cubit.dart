import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(const ContactState());

   onItemTapped(int index) {
     print(index);
    emit(state.copyWith(selectedIndex: index));
  }
}