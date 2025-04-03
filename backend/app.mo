import LLM "mo:llm";
import Blob "mo:base/Blob";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Char "mo:base/Char";
import Nat32 "mo:base/Nat32";
import Nat8 "mo:base/Nat8";
persistent actor LegalChatbot {
  
  // Function to handle direct text-based prompts
  public func prompt(prompt : Text) : async Text {
    await LLM.prompt(#Llama3_1_8B, prompt);
  };

  // Function to engage in chat-based conversation
  public func chat(messages : [LLM.ChatMessage]) : async Text {
    let formattedMessages = Array.append([
      { role = #system_; content = "You are a knowledgeable legal assistant providing accurate legal advice." }
    ], messages);
    
    await LLM.chat(#Llama3_1_8B, formattedMessages);
  };
  
  // Function to process uploaded documents
  public func uploadDocument(file : Blob) : async Text {
    let textExtracted = extractTextFromBlob(file);
    
    // Generate a summary of the legal document
    await LLM.prompt(#Llama3_1_8B, "Summarize this legal document: " # textExtracted);
  };
  
  // Helper function to convert Blob data to text
  private func extractTextFromBlob(file : Blob) : Text {
    let byteArray = Blob.toArray(file);
   let charArray = Array.map<Nat8, Text>(byteArray, func (b : Nat8) : Text {
    Text.fromChar(Char.fromNat32(Nat32.fromNat(Nat8.toNat(b))))
  });
  Text.join("", Iter.fromArray(charArray));
};

};
