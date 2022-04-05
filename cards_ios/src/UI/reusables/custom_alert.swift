//
//  textfield_alert.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 3/22/22.
//
import SwiftUI
import Combine

extension View {
    func customAlert<Content: View>(isShowing: Binding<Bool>, title: String?,@ViewBuilder content: ()->Content) -> some View {
        CustomAlertWrapper(isShowing: isShowing, presenting: self, title: title, content: content)
    }
    
//    func textFieldAlert(isPresented: Binding<Bool>, content: @escaping () -> TextFieldAlert) -> some View {
//      TextFieldWrapper(isPresented: isPresented, presentingView: self, content: content)
//    }
    func textFieldAlert(title: String, message: String, hintText: String, primaryTitle: String, primaryAction: @escaping (String) -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = hintText
        }
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: { _ in
            //TODO
        }))
        alert.addAction(.init(title: primaryTitle, style: .default, handler: { _ in
            guard let text = alert.textFields?[0].text else { return }
            primaryAction(text)
        }))
        
        rootController().present(alert, animated: true, completion: nil)
    }
}
struct testAlert: View{
    @State private var text: String? = ""
    @State private var showTextFieldAlert = false
    @State private var showCustomAlert = false
    var body: some View{
        VStack(alignment: .center){
            Button("Custom Alert") { showCustomAlert = true}
            .buttonStyle(BorderedButtonStyle())
            
            Button("TextFieldAlert") { showTextFieldAlert = true}
            .buttonStyle(BorderedButtonStyle())
        }
//            .customAlert(isShowing: $showCustomAlert, title: "Party") {
//                Text("This is My custom alert")
//            }
        
//            .textFieldAlert(isPresented: $showTextFieldAlert) { () -> TextFieldAlert in
//                    TextFieldAlert(title: "Alert Title", message: "Alert Message", text: $text)
//                }
    }
}

struct CustomAlertWrapper<Presenting, Content: View>: View where Presenting: View {
    
    @Binding var isShowing: Bool
    
    let presenting: Presenting
    let title: String?
    let width: CGFloat = 300
    @ViewBuilder var content: Content
    
    var body: some View {
        self.presenting.disabled(isShowing)
        ZStack {
            
            Color.black.opacity(0.2).ignoresSafeArea()
                .transition(.opacity)
            VStack{
                VStack{
                    if title != nil {Text(title!).fontWeight(.bold)}
                    content
                }.padding()
                
                HStack(spacing: 0){
                    Button(role: .cancel) {
                        withAnimation{isShowing = false}
                    } label: {
                        Text("Cancel")
                            .fontWeight(.semibold)
                            .frame(width: (width/2 - 0.5), height: 50)
                            .border(width: 0.5, edges: [.trailing], color: .secondary)
                    }
                    Button {
                        withAnimation{isShowing = false}
                    } label: {
                        Text("Done")
                            .frame(width: (width/2 - 0.5), height: 50)
                            .border(width: 0.5, edges: [.leading], color: .secondary)
                    }
                }.border(width: 1, edges: [.top], color: .secondary)
            }
            .frame(width: width)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
            .transition(.scale)
            //.background(Color.primary.opacity(0.2).ignoresSafeArea())
            //.shadow(radius: 1)
            
        }
    }
    
}










class TextFieldAlertViewController: UIViewController {

  /// Presents a UIAlertController (alert style) with a UITextField and a `Done` button
  /// - Parameters:
  ///   - title: to be used as title of the UIAlertController
  ///   - message: to be used as optional message of the UIAlertController
  ///   - text: binding for the text typed into the UITextField
  ///   - isPresented: binding to be set to false when the alert is dismissed (`Done` button tapped)
  init(title: String, message: String?, text: Binding<String?>, isPresented: Binding<Bool>?) {
    self.alertTitle = title
    self.message = message
    self._text = text
    self.isPresented = isPresented
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Dependencies
  private let alertTitle: String
  private let message: String?
  @Binding private var text: String?
  private var isPresented: Binding<Bool>?

  // MARK: - Private Properties
  private var subscription: AnyCancellable?

  // MARK: - Lifecycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    presentAlertController()
  }

  private func presentAlertController() {
    guard subscription == nil else { return } // present only once

    let vc = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)

    // add a textField and create a subscription to update the `text` binding
    vc.addTextField { [weak self] textField in
      guard let self = self else { return }
      self.subscription = NotificationCenter.default
        .publisher(for: UITextField.textDidChangeNotification, object: textField)
        .map { ($0.object as? UITextField)?.text }
        .assign(to: \.text, on: self)
    }

    // create a `Done` action that updates the `isPresented` binding when tapped
    // this is just for Demo only but we should really inject
    // an array of buttons (with their title, style and tap handler)
    let action = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
      self?.isPresented?.wrappedValue = false
    }
    vc.addAction(action)
    present(vc, animated: true, completion: nil)
  }
}

struct TextFieldAlert {

  // MARK: Properties
  let title: String
  let message: String?
  @Binding var text: String?
  var isPresented: Binding<Bool>? = nil

  // MARK: Modifiers
  func dismissable(_ isPresented: Binding<Bool>) -> TextFieldAlert {
    TextFieldAlert(title: title, message: message, text: $text, isPresented: isPresented)
  }
}

extension TextFieldAlert: UIViewControllerRepresentable {

  typealias UIViewControllerType = TextFieldAlertViewController

  func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlert>) -> UIViewControllerType {
    TextFieldAlertViewController(title: title, message: message, text: $text, isPresented: isPresented)
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType,
                              context: UIViewControllerRepresentableContext<TextFieldAlert>) {
    // no update needed
  }
}

struct TextFieldWrapper<PresentingView: View>: View {

  @Binding var isPresented: Bool
  let presentingView: PresentingView
  let content: () -> TextFieldAlert

  var body: some View {
    ZStack {
      if (isPresented) { content().dismissable($isPresented) }
      presentingView
    }
  }
}

struct Previews_custom_alert_Previews: PreviewProvider {
    static var previews: some View {
        testAlert()
    }
}








/**
       # Use:
                    @State private var alertType: AlertType? = nil
            .alert(item: $alertType) { $0.alert}
 */
enum AlertType: Identifiable {
    case ok(title: String, message: String? = nil)
    case singleButton(title: String, message: String? = nil, dismissButton: Alert.Button)
    case twoButtons(title: String, message: String? = nil, primaryButton: Alert.Button, secondaryButton: Alert.Button)
    
    var id: String {
        switch self {
            case .ok:
                return "ok"
            case .singleButton:
                return "singleButton"
            case .twoButtons:
                return "twoButtons"
        }
    }

    var alert: Alert {
        switch self {
        case .ok(title: let title, message: let message):
            return Alert(title: Text(title), message: message != nil ? Text(message!) : nil)
            
        case .singleButton(title: let title, message: let message, dismissButton: let dismissButton):
            return Alert(title: Text(title), message: message != nil ? Text(message!) : nil, dismissButton: dismissButton)
            
        case .twoButtons(title: let title, message: let message, primaryButton: let primaryButton, secondaryButton: let secondaryButton):
            return Alert(title: Text(title), message: message != nil ? Text(message!) : nil, primaryButton: primaryButton, secondaryButton: secondaryButton)
        }
    }
}
