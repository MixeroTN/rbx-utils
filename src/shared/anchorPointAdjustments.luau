local anchorPointAdjustments = {}

function anchorPointAdjustments:AddToUDim(UDimValue: UDim, ToAddScale: number?, ToAddOffset: number?): UDim
	return UDim.new(UDimValue.Scale + (ToAddScale or 0), UDimValue.Offset + (ToAddOffset or 0))
end

function anchorPointAdjustments:AddUDims(UDimValue: UDim, UDimToAdd: UDim): UDim
	return UDim.new(UDimValue.Scale + UDimToAdd.Scale, UDimValue.Offset + UDimToAdd.Offset)
end

function anchorPointAdjustments:MultiplyUDim(
	UDimValue: UDim,
	Scalar: number?,
	ToAddValue: number?,
	ToAddScalar: number?
): UDim
	return UDim.new(
		UDimValue.Scale + (ToAddValue or 0) * (Scalar or 1) + (ToAddScalar or 0),
		UDimValue.Offset + (ToAddValue or 0) * (Scalar or 1) + (ToAddScalar or 0)
	)
end

function anchorPointAdjustments:MultiplyUDims(
	UDimValue: UDim,
	UDimScalar: UDim,
	ToAddValue: number?,
	ToAddScalar: number?
): UDim
	local scaledUDim: UDim = UDim.new(UDimValue.Scale * UDimScalar.Scale, UDimValue.Offset * UDimScalar.Offset)
	return self:AddToUDim(scaledUDim, (ToAddValue or 0) + (ToAddScalar or 0))
end

function anchorPointAdjustments:CalculateOffset(CurrentSize: UDim2, AnchorPoint: Vector2): UDim2
	return UDim2.new(
		UDim.new(CurrentSize.X.Scale * AnchorPoint.X, CurrentSize.X.Offset * AnchorPoint.X),
		UDim.new(CurrentSize.Y.Scale * AnchorPoint.Y, CurrentSize.Y.Offset * AnchorPoint.Y)
	)
end

function anchorPointAdjustments:AdjustPosition(UIObject: GuiObject, NewAnchorPoint: Vector2): ()
	local currentPosition: UDim2 = UIObject.Position
	local currentSize: UDim2 = UIObject.Size
	local oldAnchorPoint: Vector2 = UIObject.AnchorPoint

	local oldOffset: UDim2 = self:CalculateOffset(currentSize, oldAnchorPoint)
	local newOffset: UDim2 = self:CalculateOffset(currentSize, NewAnchorPoint)

	UIObject.AnchorPoint = NewAnchorPoint
	UIObject.Position = currentPosition - oldOffset + newOffset
end

return anchorPointAdjustments
